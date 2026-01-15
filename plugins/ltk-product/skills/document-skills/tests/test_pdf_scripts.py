"""Tests for PDF processing scripts."""
import io
import json

import pytest

# Import functions to test
from fill_pdf_form_with_annotations import transform_coordinates
from fill_fillable_fields import validation_error_for_field_value
from check_bounding_boxes import get_bounding_box_messages


class TestTransformCoordinates:
    """Tests for coordinate transformation from image to PDF coordinates."""

    def test_basic_transform(self):
        """Test basic coordinate transformation with 1:1 scaling."""
        # Image: 100x100, PDF: 100x100
        bbox = [10, 20, 30, 40]  # left, top, right, bottom in image coords
        result = transform_coordinates(bbox, 100, 100, 100, 100)

        # PDF coords: origin bottom-left, y increases upward
        # left stays same: 10
        # right stays same: 30
        # top in image (20) -> 100 - 20 = 80 in PDF
        # bottom in image (40) -> 100 - 40 = 60 in PDF
        left, bottom, right, top = result
        assert left == 10
        assert right == 30
        assert top == 80  # image top -> PDF coord
        assert bottom == 60  # image bottom -> PDF coord

    def test_transform_with_scaling(self):
        """Test coordinate transformation with 2x scaling."""
        # Image: 100x100, PDF: 200x200 (2x scale)
        bbox = [10, 20, 30, 40]
        result = transform_coordinates(bbox, 100, 100, 200, 200)

        left, bottom, right, top = result
        # Coordinates should be doubled
        assert left == 20
        assert right == 60
        assert top == 160  # 200 - (20 * 2)
        assert bottom == 120  # 200 - (40 * 2)

    def test_transform_non_square(self):
        """Test transformation with non-square dimensions."""
        # Image: 100x200, PDF: 50x100 (different aspect ratio scaling)
        bbox = [20, 40, 60, 80]
        result = transform_coordinates(bbox, 100, 200, 50, 100)

        left, bottom, right, top = result
        # x_scale = 50/100 = 0.5, y_scale = 100/200 = 0.5
        assert left == 10  # 20 * 0.5
        assert right == 30  # 60 * 0.5
        assert top == 80  # 100 - (40 * 0.5) = 100 - 20
        assert bottom == 60  # 100 - (80 * 0.5) = 100 - 40

    def test_transform_origin(self):
        """Test transformation of box at origin."""
        bbox = [0, 0, 10, 10]
        result = transform_coordinates(bbox, 100, 100, 100, 100)

        left, bottom, right, top = result
        assert left == 0
        assert right == 10
        assert top == 100  # Top of image is bottom of PDF
        assert bottom == 90


class TestFieldValueValidation:
    """Tests for form field value validation."""

    def test_checkbox_valid_checked(self, sample_checkbox_field):
        """Test valid checked checkbox value."""
        error = validation_error_for_field_value(sample_checkbox_field, "Yes")
        assert error is None

    def test_checkbox_valid_unchecked(self, sample_checkbox_field):
        """Test valid unchecked checkbox value."""
        error = validation_error_for_field_value(sample_checkbox_field, "Off")
        assert error is None

    def test_checkbox_invalid_value(self, sample_checkbox_field):
        """Test invalid checkbox value returns error."""
        error = validation_error_for_field_value(sample_checkbox_field, "Maybe")
        assert error is not None
        assert "Invalid value" in error
        assert "checkbox1" in error
        assert "Maybe" in error

    def test_radio_valid_option(self, sample_radio_field):
        """Test valid radio option."""
        error = validation_error_for_field_value(sample_radio_field, "option2")
        assert error is None

    def test_radio_invalid_option(self, sample_radio_field):
        """Test invalid radio option returns error."""
        error = validation_error_for_field_value(sample_radio_field, "option99")
        assert error is not None
        assert "Invalid value" in error
        assert "radio" in error

    def test_choice_valid_option(self, sample_choice_field):
        """Test valid dropdown choice."""
        error = validation_error_for_field_value(sample_choice_field, "green")
        assert error is None

    def test_choice_invalid_option(self, sample_choice_field):
        """Test invalid dropdown choice returns error."""
        error = validation_error_for_field_value(sample_choice_field, "yellow")
        assert error is not None
        assert "Invalid value" in error
        assert "choice" in error

    def test_text_field_any_value(self, sample_text_field):
        """Test text field accepts any value (no validation)."""
        error = validation_error_for_field_value(sample_text_field, "any text value")
        assert error is None


class TestBoundingBoxValidation:
    """Tests for bounding box validation (migrated from unittest)."""

    def create_json_stream(self, data):
        """Helper to create a JSON stream from data."""
        return io.StringIO(json.dumps(data))

    def test_no_intersections(self):
        """Test case with no bounding box intersections."""
        data = {
            "form_fields": [
                {
                    "description": "Name",
                    "page_number": 1,
                    "label_bounding_box": [10, 10, 50, 30],
                    "entry_bounding_box": [60, 10, 150, 30],
                },
                {
                    "description": "Email",
                    "page_number": 1,
                    "label_bounding_box": [10, 40, 50, 60],
                    "entry_bounding_box": [60, 40, 150, 60],
                },
            ]
        }
        stream = self.create_json_stream(data)
        messages = get_bounding_box_messages(stream)
        assert any("SUCCESS" in msg for msg in messages)
        assert not any("FAILURE" in msg for msg in messages)

    def test_label_entry_intersection_same_field(self):
        """Test intersection between label and entry of the same field."""
        data = {
            "form_fields": [
                {
                    "description": "Name",
                    "page_number": 1,
                    "label_bounding_box": [10, 10, 60, 30],
                    "entry_bounding_box": [50, 10, 150, 30],  # Overlaps with label
                }
            ]
        }
        stream = self.create_json_stream(data)
        messages = get_bounding_box_messages(stream)
        assert any("FAILURE" in msg and "intersection" in msg for msg in messages)
        assert not any("SUCCESS" in msg for msg in messages)

    def test_intersection_between_different_fields(self):
        """Test intersection between bounding boxes of different fields."""
        data = {
            "form_fields": [
                {
                    "description": "Name",
                    "page_number": 1,
                    "label_bounding_box": [10, 10, 50, 30],
                    "entry_bounding_box": [60, 10, 150, 30],
                },
                {
                    "description": "Email",
                    "page_number": 1,
                    "label_bounding_box": [40, 20, 80, 40],  # Overlaps with Name
                    "entry_bounding_box": [160, 10, 250, 30],
                },
            ]
        }
        stream = self.create_json_stream(data)
        messages = get_bounding_box_messages(stream)
        assert any("FAILURE" in msg and "intersection" in msg for msg in messages)
        assert not any("SUCCESS" in msg for msg in messages)

    def test_different_pages_no_intersection(self):
        """Test that boxes on different pages don't count as intersecting."""
        data = {
            "form_fields": [
                {
                    "description": "Name",
                    "page_number": 1,
                    "label_bounding_box": [10, 10, 50, 30],
                    "entry_bounding_box": [60, 10, 150, 30],
                },
                {
                    "description": "Email",
                    "page_number": 2,
                    "label_bounding_box": [10, 10, 50, 30],  # Same coords, different page
                    "entry_bounding_box": [60, 10, 150, 30],
                },
            ]
        }
        stream = self.create_json_stream(data)
        messages = get_bounding_box_messages(stream)
        assert any("SUCCESS" in msg for msg in messages)
        assert not any("FAILURE" in msg for msg in messages)

    def test_entry_height_too_small(self):
        """Test that entry box height is checked against font size."""
        data = {
            "form_fields": [
                {
                    "description": "Name",
                    "page_number": 1,
                    "label_bounding_box": [10, 10, 50, 30],
                    "entry_bounding_box": [60, 10, 150, 20],  # Height is 10
                    "entry_text": {"font_size": 14},  # Font larger than height
                }
            ]
        }
        stream = self.create_json_stream(data)
        messages = get_bounding_box_messages(stream)
        assert any("FAILURE" in msg and "height" in msg for msg in messages)
        assert not any("SUCCESS" in msg for msg in messages)

    def test_entry_height_adequate(self):
        """Test that adequate entry box height passes."""
        data = {
            "form_fields": [
                {
                    "description": "Name",
                    "page_number": 1,
                    "label_bounding_box": [10, 10, 50, 30],
                    "entry_bounding_box": [60, 10, 150, 30],  # Height is 20
                    "entry_text": {"font_size": 14},  # Font smaller than height
                }
            ]
        }
        stream = self.create_json_stream(data)
        messages = get_bounding_box_messages(stream)
        assert any("SUCCESS" in msg for msg in messages)
        assert not any("FAILURE" in msg for msg in messages)

    def test_no_entry_text(self):
        """Test that missing entry_text doesn't cause height check."""
        data = {
            "form_fields": [
                {
                    "description": "Name",
                    "page_number": 1,
                    "label_bounding_box": [10, 10, 50, 30],
                    "entry_bounding_box": [60, 10, 150, 20],  # Small but no entry_text
                }
            ]
        }
        stream = self.create_json_stream(data)
        messages = get_bounding_box_messages(stream)
        assert any("SUCCESS" in msg for msg in messages)
        assert not any("FAILURE" in msg for msg in messages)

    def test_default_font_size(self):
        """Test that default font size is used when not specified."""
        data = {
            "form_fields": [
                {
                    "description": "Name",
                    "page_number": 1,
                    "label_bounding_box": [10, 10, 50, 30],
                    "entry_bounding_box": [60, 10, 150, 20],  # Height is 10
                    "entry_text": {},  # No font_size specified, should use default 14
                }
            ]
        }
        stream = self.create_json_stream(data)
        messages = get_bounding_box_messages(stream)
        assert any("FAILURE" in msg and "height" in msg for msg in messages)
        assert not any("SUCCESS" in msg for msg in messages)

    def test_edge_touching_boxes(self):
        """Test that boxes touching at edges don't count as intersecting."""
        data = {
            "form_fields": [
                {
                    "description": "Name",
                    "page_number": 1,
                    "label_bounding_box": [10, 10, 50, 30],
                    "entry_bounding_box": [50, 10, 150, 30],  # Touches at x=50
                }
            ]
        }
        stream = self.create_json_stream(data)
        messages = get_bounding_box_messages(stream)
        assert any("SUCCESS" in msg for msg in messages)
        assert not any("FAILURE" in msg for msg in messages)

    def test_multiple_errors_limit(self):
        """Test that error messages are limited to prevent excessive output."""
        fields = []
        for i in range(25):
            fields.append(
                {
                    "description": f"Field{i}",
                    "page_number": 1,
                    "label_bounding_box": [10, 10, 50, 30],  # All overlap
                    "entry_bounding_box": [20, 15, 60, 35],
                }
            )
        data = {"form_fields": fields}
        stream = self.create_json_stream(data)
        messages = get_bounding_box_messages(stream)

        # Should abort after ~20 messages
        assert any("Aborting" in msg for msg in messages)
        failure_count = sum(1 for msg in messages if "FAILURE" in msg)
        assert failure_count > 0
        assert len(messages) < 30  # Should be limited
