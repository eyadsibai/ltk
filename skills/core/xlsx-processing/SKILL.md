---
name: xlsx-processing
description: Use when working with "Excel", "spreadsheets", "XLSX files", "CSV data", "formulas", "openpyxl", "pandas Excel", or asking about "Excel manipulation", "spreadsheet analysis", "financial models"
version: 1.0.0
---

<!-- Adapted from: awesome-claude-skills/document-skills/xlsx -->

# Excel/Spreadsheet Processing Guide

Create, edit, and analyze spreadsheets with formulas and formatting.

## Library Selection

| Task | Best Tool |
|------|-----------|
| Data analysis | pandas |
| Formulas & formatting | openpyxl |
| Simple CSV | pandas |
| Financial models | openpyxl |

## Reading Data with Pandas

```python
import pandas as pd

# Read Excel
df = pd.read_excel('file.xlsx')  # First sheet
all_sheets = pd.read_excel('file.xlsx', sheet_name=None)  # All sheets

# Analyze
df.head()       # Preview
df.info()       # Column info
df.describe()   # Statistics

# Write
df.to_excel('output.xlsx', index=False)
```

## Creating with openpyxl

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment

wb = Workbook()
sheet = wb.active

# Add data
sheet['A1'] = 'Revenue'
sheet['B1'] = 1000
sheet.append(['Q1', 'Q2', 'Q3', 'Q4'])

# Add formula (NEVER hardcode calculations!)
sheet['B5'] = '=SUM(B1:B4)'

# Formatting
sheet['A1'].font = Font(bold=True)
sheet['A1'].fill = PatternFill('solid', fgColor='FFFF00')
sheet.column_dimensions['A'].width = 15

wb.save('output.xlsx')
```

## Critical: Use Formulas, Not Hardcoded Values

```python
# ❌ WRONG - Hardcoding
total = df['Sales'].sum()
sheet['B10'] = total  # Hardcodes 5000

# ✅ CORRECT - Excel formula
sheet['B10'] = '=SUM(B2:B9)'
```

## Editing Existing Files

```python
from openpyxl import load_workbook

wb = load_workbook('existing.xlsx')
sheet = wb.active

# Modify
sheet['A1'] = 'New Value'
sheet.insert_rows(2)
sheet.delete_cols(3)

# Add sheet
new_sheet = wb.create_sheet('NewSheet')

wb.save('modified.xlsx')
```

## Financial Model Standards

### Color Coding

| Color | Use |
|-------|-----|
| Blue text | Hardcoded inputs |
| Black text | Formulas |
| Green text | Links to other sheets |
| Yellow fill | Needs attention |

### Number Formats

```python
# Currency
sheet['A1'].number_format = '$#,##0'

# Percentage
sheet['B1'].number_format = '0.0%'

# Negative in parentheses
sheet['C1'].number_format = '#,##0;(#,##0)'
```

## Common Formula Errors

| Error | Cause | Fix |
|-------|-------|-----|
| #REF! | Invalid reference | Check cell exists |
| #DIV/0! | Division by zero | Add IF check |
| #VALUE! | Wrong data type | Verify inputs |
| #NAME? | Unknown function | Check spelling |

## Best Practices

1. **Always use formulas** - Never hardcode calculations
2. **Document sources** - Comment cells with data sources
3. **Test formulas** - Verify with sample data first
4. **Preserve formatting** - Use `load_workbook()` not pandas for edits
5. **Handle data_only carefully** - Using `data_only=True` loses formulas on save

## Required Packages

```bash
pip install pandas openpyxl xlrd
```
