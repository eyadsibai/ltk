"""Tests for OOXML pack/unpack scripts."""
import tempfile
import zipfile
from pathlib import Path

import pytest

# Import functions to test
from pack import condense_xml, pack_document


class TestCondenseXml:
    """Tests for XML condensing function."""

    def test_removes_whitespace_between_elements(self, tmp_path):
        """Test that whitespace between elements is removed."""
        xml_content = """<?xml version="1.0" encoding="UTF-8"?>
<root>
    <child1>
        <nested/>
    </child1>
    <child2/>
</root>"""
        xml_file = tmp_path / "test.xml"
        xml_file.write_text(xml_content, encoding="utf-8")

        condense_xml(xml_file)

        result = xml_file.read_text(encoding="utf-8")
        # Should not have newlines between elements (except in declaration)
        assert "\n    <child" not in result
        assert "<root><child1>" in result or "<root>\n<child1>" not in result

    def test_preserves_text_content_in_t_elements(self, tmp_path):
        """Test that w:t element text content is preserved."""
        xml_content = """<?xml version="1.0" encoding="UTF-8"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
    <w:body>
        <w:p>
            <w:r>
                <w:t>Hello World</w:t>
            </w:r>
        </w:p>
    </w:body>
</w:document>"""
        xml_file = tmp_path / "document.xml"
        xml_file.write_text(xml_content, encoding="utf-8")

        condense_xml(xml_file)

        result = xml_file.read_text(encoding="utf-8")
        # Text content inside w:t must be preserved
        assert "Hello World" in result

    def test_removes_comments(self, tmp_path):
        """Test that XML comments are removed."""
        xml_content = """<?xml version="1.0" encoding="UTF-8"?>
<root>
    <!-- This is a comment -->
    <child>content</child>
    <!-- Another comment -->
</root>"""
        xml_file = tmp_path / "test.xml"
        xml_file.write_text(xml_content, encoding="utf-8")

        condense_xml(xml_file)

        result = xml_file.read_text(encoding="utf-8")
        # Comments should be removed
        assert "This is a comment" not in result
        assert "Another comment" not in result
        # But content should remain
        assert "content" in result

    def test_handles_rels_files(self, tmp_path):
        """Test that .rels files are processed correctly."""
        xml_content = """<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
    <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>"""
        xml_file = tmp_path / "document.xml.rels"
        xml_file.write_text(xml_content, encoding="utf-8")

        condense_xml(xml_file)

        result = xml_file.read_text(encoding="utf-8")
        # Relationship should be preserved
        assert "rId1" in result
        assert "document.xml" in result


class TestPackDocument:
    """Tests for document packing function."""

    def create_minimal_docx_structure(self, base_dir):
        """Create minimal valid DOCX structure for testing."""
        # Required directories
        (base_dir / "_rels").mkdir()
        (base_dir / "word").mkdir()
        (base_dir / "word" / "_rels").mkdir()

        # [Content_Types].xml
        content_types = """<?xml version="1.0" encoding="UTF-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>"""
        (base_dir / "[Content_Types].xml").write_text(content_types, encoding="utf-8")

        # _rels/.rels
        rels = """<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>"""
        (base_dir / "_rels" / ".rels").write_text(rels, encoding="utf-8")

        # word/document.xml
        document = """<?xml version="1.0" encoding="UTF-8"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:body><w:p><w:r><w:t>Test content</w:t></w:r></w:p></w:body>
</w:document>"""
        (base_dir / "word" / "document.xml").write_text(document, encoding="utf-8")

        # word/_rels/document.xml.rels
        doc_rels = """<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
</Relationships>"""
        (base_dir / "word" / "_rels" / "document.xml.rels").write_text(
            doc_rels, encoding="utf-8"
        )

    def test_pack_creates_valid_zip(self, tmp_path):
        """Test that packing creates a valid zip file."""
        # Create input structure
        input_dir = tmp_path / "input"
        input_dir.mkdir()
        self.create_minimal_docx_structure(input_dir)

        # Pack
        output_file = tmp_path / "output.docx"
        result = pack_document(input_dir, output_file, validate=False)

        assert result is True
        assert output_file.exists()
        # Verify it's a valid zip
        assert zipfile.is_zipfile(output_file)

    def test_pack_contains_expected_files(self, tmp_path):
        """Test that packed file contains expected contents."""
        input_dir = tmp_path / "input"
        input_dir.mkdir()
        self.create_minimal_docx_structure(input_dir)

        output_file = tmp_path / "output.docx"
        pack_document(input_dir, output_file, validate=False)

        with zipfile.ZipFile(output_file, "r") as zf:
            names = zf.namelist()
            assert "[Content_Types].xml" in names
            assert "_rels/.rels" in names
            assert "word/document.xml" in names

    def test_pack_preserves_text_content(self, tmp_path):
        """Test that text content is preserved after packing."""
        input_dir = tmp_path / "input"
        input_dir.mkdir()
        self.create_minimal_docx_structure(input_dir)

        output_file = tmp_path / "output.docx"
        pack_document(input_dir, output_file, validate=False)

        with zipfile.ZipFile(output_file, "r") as zf:
            doc_content = zf.read("word/document.xml").decode("utf-8")
            assert "Test content" in doc_content

    def test_pack_rejects_invalid_extension(self, tmp_path):
        """Test that invalid file extensions are rejected."""
        input_dir = tmp_path / "input"
        input_dir.mkdir()
        self.create_minimal_docx_structure(input_dir)

        output_file = tmp_path / "output.txt"
        with pytest.raises(ValueError, match="must be a .docx"):
            pack_document(input_dir, output_file, validate=False)

    def test_pack_rejects_nonexistent_input(self, tmp_path):
        """Test that nonexistent input directory is rejected."""
        input_dir = tmp_path / "nonexistent"
        output_file = tmp_path / "output.docx"

        with pytest.raises(ValueError, match="not a directory"):
            pack_document(input_dir, output_file, validate=False)

    def test_pack_supports_pptx(self, tmp_path):
        """Test that packing works for .pptx files."""
        input_dir = tmp_path / "input"
        input_dir.mkdir()
        # Create minimal structure (reuse docx, it just needs valid zip)
        (input_dir / "test.xml").write_text(
            '<?xml version="1.0"?><root/>', encoding="utf-8"
        )

        output_file = tmp_path / "output.pptx"
        result = pack_document(input_dir, output_file, validate=False)

        assert result is True
        assert output_file.exists()

    def test_pack_supports_xlsx(self, tmp_path):
        """Test that packing works for .xlsx files."""
        input_dir = tmp_path / "input"
        input_dir.mkdir()
        (input_dir / "test.xml").write_text(
            '<?xml version="1.0"?><root/>', encoding="utf-8"
        )

        output_file = tmp_path / "output.xlsx"
        result = pack_document(input_dir, output_file, validate=False)

        assert result is True
        assert output_file.exists()


class TestRoundtrip:
    """Tests for pack/unpack roundtrip."""

    def test_content_preserved_after_roundtrip(self, tmp_path):
        """Test that content is preserved when unpacking and repacking."""
        # Create a simple docx-like structure
        original_dir = tmp_path / "original"
        original_dir.mkdir()
        (original_dir / "_rels").mkdir()
        (original_dir / "word").mkdir()

        original_content = "This is important text that must be preserved!"
        doc_xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:body><w:p><w:r><w:t>{original_content}</w:t></w:r></w:p></w:body>
</w:document>"""

        (original_dir / "word" / "document.xml").write_text(doc_xml, encoding="utf-8")
        (original_dir / "[Content_Types].xml").write_text(
            '<?xml version="1.0"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"/>',
            encoding="utf-8",
        )
        (original_dir / "_rels" / ".rels").write_text(
            '<?xml version="1.0"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"/>',
            encoding="utf-8",
        )

        # Pack
        packed_file = tmp_path / "test.docx"
        pack_document(original_dir, packed_file, validate=False)

        # Unpack (manually, since unpack.py is a script)
        unpacked_dir = tmp_path / "unpacked"
        unpacked_dir.mkdir()
        with zipfile.ZipFile(packed_file, "r") as zf:
            zf.extractall(unpacked_dir)

        # Verify content preserved
        unpacked_doc = (unpacked_dir / "word" / "document.xml").read_text(
            encoding="utf-8"
        )
        assert original_content in unpacked_doc
