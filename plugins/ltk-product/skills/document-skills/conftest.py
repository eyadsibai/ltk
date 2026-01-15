"""Shared pytest fixtures for document-skills tests."""
import json
import sys
from pathlib import Path

import pytest

# Add script directories to path for imports
SKILLS_DIR = Path(__file__).parent
PDF_SCRIPTS = SKILLS_DIR / "pdf" / "scripts"
PPTX_OOXML_SCRIPTS = SKILLS_DIR / "pptx" / "ooxml" / "scripts"
DOCX_OOXML_SCRIPTS = SKILLS_DIR / "docx" / "ooxml" / "scripts"

sys.path.insert(0, str(PDF_SCRIPTS))
sys.path.insert(0, str(PPTX_OOXML_SCRIPTS))
sys.path.insert(0, str(DOCX_OOXML_SCRIPTS))


@pytest.fixture
def fixtures_dir():
    """Return path to test fixtures directory."""
    return Path(__file__).parent / "tests" / "fixtures"


@pytest.fixture
def sample_fields_json(fixtures_dir):
    """Load sample form fields JSON data."""
    with open(fixtures_dir / "sample_fields.json") as f:
        return json.load(f)


@pytest.fixture
def sample_checkbox_field():
    """Sample checkbox field info for validation tests."""
    return {
        "field_id": "checkbox1",
        "type": "checkbox",
        "checked_value": "Yes",
        "unchecked_value": "Off",
    }


@pytest.fixture
def sample_radio_field():
    """Sample radio group field info for validation tests."""
    return {
        "field_id": "radio1",
        "type": "radio_group",
        "radio_options": [
            {"value": "option1", "label": "Option 1"},
            {"value": "option2", "label": "Option 2"},
            {"value": "option3", "label": "Option 3"},
        ],
    }


@pytest.fixture
def sample_choice_field():
    """Sample choice/dropdown field info for validation tests."""
    return {
        "field_id": "dropdown1",
        "type": "choice",
        "choice_options": [
            {"value": "red", "label": "Red"},
            {"value": "green", "label": "Green"},
            {"value": "blue", "label": "Blue"},
        ],
    }


@pytest.fixture
def sample_text_field():
    """Sample text field info."""
    return {
        "field_id": "textfield1",
        "type": "text",
        "page": 1,
    }
