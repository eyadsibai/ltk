"""Tests for validation modules."""
import tempfile
from pathlib import Path
from xml.etree import ElementTree as ET

import pytest

# Add validation directory to path
import sys

DOCX_VALIDATION_DIR = (
    Path(__file__).parent.parent / "docx" / "ooxml" / "scripts" / "validation"
)
sys.path.insert(0, str(DOCX_VALIDATION_DIR))

from base import BaseSchemaValidator
from redlining import RedliningValidator


class TestBaseValidatorXml:
    """Tests for XML validation in base validator."""

    def create_validator(self, tmp_path, files_dict):
        """Create a validator with given files."""
        for filename, content in files_dict.items():
            file_path = tmp_path / filename
            file_path.parent.mkdir(parents=True, exist_ok=True)
            file_path.write_text(content, encoding="utf-8")

        # Create a minimal original file (not used in these tests but required)
        original_file = tmp_path / "original.docx"
        original_file.touch()

        return BaseSchemaValidator(tmp_path, original_file, verbose=False)

    def test_validate_xml_wellformed(self, tmp_path):
        """Test that well-formed XML passes validation."""
        validator = self.create_validator(
            tmp_path, {"test.xml": '<?xml version="1.0"?><root><child/></root>'}
        )
        result = validator.validate_xml()
        assert result is True

    def test_validate_xml_malformed(self, tmp_path, capsys):
        """Test that malformed XML fails validation."""
        validator = self.create_validator(
            tmp_path, {"test.xml": '<?xml version="1.0"?><root><child></root>'}
        )
        result = validator.validate_xml()
        assert result is False
        captured = capsys.readouterr()
        assert "FAILED" in captured.out

    def test_validate_xml_multiple_files(self, tmp_path):
        """Test validation with multiple XML files."""
        validator = self.create_validator(
            tmp_path,
            {
                "file1.xml": '<?xml version="1.0"?><root1/>',
                "file2.xml": '<?xml version="1.0"?><root2/>',
                "subdir/file3.xml": '<?xml version="1.0"?><root3/>',
            },
        )
        result = validator.validate_xml()
        assert result is True


class TestBaseValidatorNamespaces:
    """Tests for namespace validation."""

    def create_validator(self, tmp_path, content):
        """Create a validator with single XML file."""
        (tmp_path / "test.xml").write_text(content, encoding="utf-8")
        original_file = tmp_path / "original.docx"
        original_file.touch()
        return BaseSchemaValidator(tmp_path, original_file, verbose=False)

    def test_validate_namespaces_all_declared(self, tmp_path):
        """Test that declared namespaces in Ignorable pass validation."""
        content = """<?xml version="1.0"?>
<root xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
      xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml"
      mc:Ignorable="w14">
</root>"""
        validator = self.create_validator(tmp_path, content)
        result = validator.validate_namespaces()
        assert result is True

    def test_validate_namespaces_undeclared(self, tmp_path, capsys):
        """Test that undeclared namespaces in Ignorable fail validation."""
        content = """<?xml version="1.0"?>
<root xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
      mc:Ignorable="w14 w15">
</root>"""
        validator = self.create_validator(tmp_path, content)
        result = validator.validate_namespaces()
        assert result is False
        captured = capsys.readouterr()
        assert "FAILED" in captured.out
        assert "w14" in captured.out or "w15" in captured.out


class TestBaseValidatorUniqueIds:
    """Tests for ID uniqueness validation."""

    def create_validator(self, tmp_path, content):
        """Create a validator with single XML file."""
        (tmp_path / "test.xml").write_text(content, encoding="utf-8")
        original_file = tmp_path / "original.docx"
        original_file.touch()
        return BaseSchemaValidator(tmp_path, original_file, verbose=False)

    def test_validate_unique_ids_no_duplicates(self, tmp_path):
        """Test that unique IDs pass validation."""
        content = """<?xml version="1.0"?>
<root xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
    <w:comment w:id="1"/>
    <w:comment w:id="2"/>
    <w:comment w:id="3"/>
</root>"""
        validator = self.create_validator(tmp_path, content)
        result = validator.validate_unique_ids()
        assert result is True

    def test_validate_unique_ids_with_duplicates(self, tmp_path, capsys):
        """Test that duplicate IDs fail validation."""
        content = """<?xml version="1.0"?>
<root xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
    <w:comment w:id="1"/>
    <w:comment w:id="1"/>
</root>"""
        validator = self.create_validator(tmp_path, content)
        result = validator.validate_unique_ids()
        assert result is False
        captured = capsys.readouterr()
        assert "FAILED" in captured.out
        assert "Duplicate" in captured.out


class TestBaseValidatorFileReferences:
    """Tests for file reference validation."""

    def create_validator_with_rels(self, tmp_path, rels_content, target_files=None):
        """Create a validator with .rels file and optional target files."""
        # Create unpacked directory (separate from original file location)
        unpacked_dir = tmp_path / "unpacked"
        unpacked_dir.mkdir()

        # Create _rels directory and .rels file
        rels_dir = unpacked_dir / "_rels"
        rels_dir.mkdir()
        (rels_dir / ".rels").write_text(rels_content, encoding="utf-8")

        # Create target files if specified
        if target_files:
            for target in target_files:
                target_path = unpacked_dir / target
                target_path.parent.mkdir(parents=True, exist_ok=True)
                target_path.write_text("<root/>", encoding="utf-8")

        # Create original file OUTSIDE unpacked directory
        original_file = tmp_path / "original.docx"
        original_file.touch()

        return BaseSchemaValidator(unpacked_dir, original_file, verbose=False)

    def test_validate_file_references_valid(self, tmp_path):
        """Test that valid file references pass."""
        rels_content = """<?xml version="1.0"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
    <Relationship Id="rId1" Type="http://test" Target="word/document.xml"/>
</Relationships>"""
        validator = self.create_validator_with_rels(
            tmp_path, rels_content, target_files=["word/document.xml"]
        )
        result = validator.validate_file_references()
        assert result is True

    def test_validate_file_references_broken(self, tmp_path, capsys):
        """Test that broken file references fail."""
        rels_content = """<?xml version="1.0"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
    <Relationship Id="rId1" Type="http://test" Target="word/missing.xml"/>
</Relationships>"""
        validator = self.create_validator_with_rels(
            tmp_path, rels_content, target_files=[]
        )
        result = validator.validate_file_references()
        assert result is False
        captured = capsys.readouterr()
        assert "FAILED" in captured.out
        assert "Broken reference" in captured.out

    def test_validate_file_references_external_urls_skipped(self, tmp_path):
        """Test that external URLs are not validated as file references."""
        rels_content = """<?xml version="1.0"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
    <Relationship Id="rId1" Type="http://test" Target="http://example.com"/>
    <Relationship Id="rId2" Type="http://test" Target="mailto:test@example.com"/>
</Relationships>"""
        validator = self.create_validator_with_rels(tmp_path, rels_content)
        result = validator.validate_file_references()
        assert result is True


class TestRedliningValidator:
    """Tests for redlining (tracked changes) validation."""

    W_NS = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"

    def create_document_xml(self, body_content):
        """Create a minimal Word document.xml with given body content."""
        return f"""<?xml version="1.0" encoding="UTF-8"?>
<w:document xmlns:w="{self.W_NS}">
<w:body>{body_content}</w:body>
</w:document>"""

    def test_extract_text_content_simple(self, tmp_path):
        """Test text extraction from simple document."""
        doc_content = self.create_document_xml(
            """<w:p><w:r><w:t>Hello World</w:t></w:r></w:p>"""
        )
        (tmp_path / "word").mkdir()
        (tmp_path / "word" / "document.xml").write_text(doc_content, encoding="utf-8")

        validator = RedliningValidator(tmp_path, tmp_path / "test.docx")
        root = ET.parse(tmp_path / "word" / "document.xml").getroot()

        text = validator._extract_text_content(root)
        assert text == "Hello World"

    def test_extract_text_content_multiple_paragraphs(self, tmp_path):
        """Test text extraction preserves paragraph structure."""
        doc_content = self.create_document_xml(
            """
            <w:p><w:r><w:t>First paragraph</w:t></w:r></w:p>
            <w:p><w:r><w:t>Second paragraph</w:t></w:r></w:p>
            """
        )
        (tmp_path / "word").mkdir()
        (tmp_path / "word" / "document.xml").write_text(doc_content, encoding="utf-8")

        validator = RedliningValidator(tmp_path, tmp_path / "test.docx")
        root = ET.parse(tmp_path / "word" / "document.xml").getroot()

        text = validator._extract_text_content(root)
        assert "First paragraph" in text
        assert "Second paragraph" in text

    def test_extract_text_content_skips_empty_paragraphs(self, tmp_path):
        """Test that empty paragraphs are skipped."""
        doc_content = self.create_document_xml(
            """
            <w:p><w:r><w:t>Content</w:t></w:r></w:p>
            <w:p></w:p>
            <w:p><w:r></w:r></w:p>
            """
        )
        (tmp_path / "word").mkdir()
        (tmp_path / "word" / "document.xml").write_text(doc_content, encoding="utf-8")

        validator = RedliningValidator(tmp_path, tmp_path / "test.docx")
        root = ET.parse(tmp_path / "word" / "document.xml").getroot()

        text = validator._extract_text_content(root)
        assert text == "Content"

    def test_remove_claude_tracked_changes_ins(self, tmp_path):
        """Test that Claude's insertions are removed."""
        doc_content = self.create_document_xml(
            f"""
            <w:p>
                <w:r><w:t>Original text</w:t></w:r>
                <w:ins w:author="Claude">
                    <w:r><w:t> added by Claude</w:t></w:r>
                </w:ins>
            </w:p>
            """
        )
        (tmp_path / "word").mkdir()
        (tmp_path / "word" / "document.xml").write_text(doc_content, encoding="utf-8")

        validator = RedliningValidator(tmp_path, tmp_path / "test.docx")
        root = ET.parse(tmp_path / "word" / "document.xml").getroot()

        validator._remove_claude_tracked_changes(root)
        text = validator._extract_text_content(root)

        # Claude's insertion should be removed
        assert "added by Claude" not in text
        assert "Original text" in text

    def test_remove_claude_tracked_changes_preserves_other_authors(self, tmp_path):
        """Test that other authors' tracked changes are preserved."""
        doc_content = self.create_document_xml(
            f"""
            <w:p>
                <w:r><w:t>Original</w:t></w:r>
                <w:ins w:author="OtherUser">
                    <w:r><w:t> by other</w:t></w:r>
                </w:ins>
                <w:ins w:author="Claude">
                    <w:r><w:t> by Claude</w:t></w:r>
                </w:ins>
            </w:p>
            """
        )
        (tmp_path / "word").mkdir()
        (tmp_path / "word" / "document.xml").write_text(doc_content, encoding="utf-8")

        validator = RedliningValidator(tmp_path, tmp_path / "test.docx")
        root = ET.parse(tmp_path / "word" / "document.xml").getroot()

        validator._remove_claude_tracked_changes(root)
        text = validator._extract_text_content(root)

        # Claude's insertion should be removed, but OtherUser's should remain
        assert "by Claude" not in text
        assert "by other" in text

    def test_remove_claude_tracked_changes_del(self, tmp_path):
        """Test that Claude's deletions are restored (delText becomes t)."""
        doc_content = self.create_document_xml(
            f"""
            <w:p>
                <w:r><w:t>Keep this</w:t></w:r>
                <w:del w:author="Claude">
                    <w:r><w:delText> restore this</w:delText></w:r>
                </w:del>
            </w:p>
            """
        )
        (tmp_path / "word").mkdir()
        (tmp_path / "word" / "document.xml").write_text(doc_content, encoding="utf-8")

        validator = RedliningValidator(tmp_path, tmp_path / "test.docx")
        root = ET.parse(tmp_path / "word" / "document.xml").getroot()

        validator._remove_claude_tracked_changes(root)
        text = validator._extract_text_content(root)

        # Claude's deletion should be unwrapped (text restored)
        assert "Keep this" in text
        assert "restore this" in text
