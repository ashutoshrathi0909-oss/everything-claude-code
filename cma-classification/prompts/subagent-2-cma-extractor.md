# SUBAGENT 2: Sonnet CMA Extractor — Extract CMA Form from Excel

> **Model**: Sonnet
> **When to use**: Always — every company has a CMA in the Excel workbook
> **Context**: Fresh window — upload the Excel workbook, paste this prompt

---

## PROMPT (copy everything below this line)

You are extracting the CMA (Credit Monitoring Arrangement) form data from this Excel workbook. The CMA is a standardized Indian banking format used for credit appraisal.

## STEP 1: IDENTIFY THE CMA SHEET(S)

Look through ALL sheets in the workbook. The CMA form typically appears in sheets named:
- "CMA", "CMA Data", "CMA Form"
- "Form I", "Form II", "Form III" (CMA has multiple forms)
- "Operating Statement", "Balance Sheet (CMA)", "Fund Flow"
- "Assessment of Working Capital"
- Or sometimes embedded within sheets with other data

List ALL sheets you find and their purpose.

## STEP 2: EXTRACT CMA ROWS

The CMA Operating Statement (Form I) typically has these sections. Extract EVERY non-zero row:

### SALES & INCOME (Rows ~22-40)
- Sales of Finished Goods (Domestic/Export)
- Sale of Raw Materials/Scrap
- Other Operating Income
- Non-Operating Income items
- Total Sales / Gross Sales / Net Sales

### MANUFACTURING/PRODUCTION EXPENSES (Rows ~42-60)
- Raw Material Consumed
- Stores & Spares Consumed
- Power & Fuel
- Direct Labour / Wages
- Repairs & Maintenance (Plant, Building)
- Depreciation (Manufacturing)
- Other Manufacturing Expenses
- Total Manufacturing Cost
- Add: Opening WIP, Less: Closing WIP
- Cost of Production

### ADMINISTRATIVE EXPENSES (Rows ~62-80)
- Salaries & Wages (Admin/Office)
- Rent, Rates & Taxes
- Insurance
- Depreciation (Admin)
- Other Admin Expenses

### SELLING & DISTRIBUTION EXPENSES (Rows ~82-95)
- Selling Expenses
- Distribution/Freight
- Commission/Brokerage
- Advertisement

### OTHER ITEMS (Rows ~96-108)
- Interest & Finance Charges
- Preliminary Expenses Written Off
- Provision for Tax

### BALANCE SHEET — CURRENT ASSETS (Rows ~200-225)
- Raw Materials
- Work in Progress
- Finished Goods
- Stores & Spares
- Trade Receivables / Debtors
- Cash & Bank
- Other Current Assets
- Loans & Advances (Current)

### BALANCE SHEET — CURRENT LIABILITIES (Rows ~226-260)
- Trade Payables / Creditors
- Statutory Liabilities
- Other Current Liabilities
- Provisions (Current)
- Bank Borrowings (Working Capital)

### BALANCE SHEET — FIXED ASSETS & TERM LIABILITIES (Rows ~260-280)
- Gross Fixed Assets
- Depreciation (Accumulated)
- Net Fixed Assets
- Term Loans
- Share Capital
- Reserves & Surplus

## STEP 3: EXTRACT METADATA

From the workbook, also identify:
- **Industry type**: Look at the nature of business, product descriptions, manufacturing accounts — is it manufacturing, services, trading, construction, etc.?
- **Entity type**: Private Limited, Partnership, LLP, Proprietorship, Public Limited
- **Financial year**: Current year and previous year(s)
- **Number of years**: CMA often has projections — note which columns are actual vs projected

## OUTPUT FORMAT

```json
{
  "extraction_metadata": {
    "industry_type": "manufacturing",
    "entity_type": "private_limited",
    "financial_year_current": "2023-24",
    "financial_year_previous": "2022-23",
    "has_projections": true,
    "projection_years": ["2024-25", "2025-26"],
    "currency_unit": "lakhs"
  },

  "sheets_found": [
    {"name": "CMA OS", "purpose": "CMA Operating Statement (Form I)"},
    {"name": "CMA BS", "purpose": "CMA Balance Sheet (Form II)"},
    {"name": "Notes to P&L", "purpose": "Detailed P&L notes with breakdowns"},
    {"name": "Notes to BS", "purpose": "Detailed Balance Sheet notes"},
    {"name": "Depreciation", "purpose": "Asset-wise depreciation schedule"}
  ],

  "cma_rows": [
    {
      "cma_row_number": 22,
      "cma_field_name": "Sales of Finished Goods (Domestic)",
      "cma_section": "sales",
      "amount_current_year": 4500000,
      "amount_previous_year": 3800000,
      "amount_projected_1": 5000000,
      "is_subtotal": false,
      "component_rows": null,
      "excel_row_ref": "CMA OS!B15"
    },
    {
      "cma_row_number": 30,
      "cma_field_name": "Gross Sales",
      "cma_section": "sales",
      "amount_current_year": 5000000,
      "amount_previous_year": 4200000,
      "is_subtotal": true,
      "component_rows": [22, 23, 24, 25, 28],
      "excel_row_ref": "CMA OS!B22"
    }
  ],

  "validation": {
    "operating_statement_balanced": true,
    "balance_sheet_balanced": true,
    "subtotals_verified": true,
    "issues": []
  }
}
```

## CRITICAL INSTRUCTIONS

1. **IDENTIFY CMA ROW NUMBERS CORRECTLY.** The CMA format has standard row numbers (22 for domestic sales, etc.). Match each extracted item to its standard CMA row number. If the workbook uses its own numbering, MAP it to the standard CMA format.

2. **EXTRACT ALL NON-ZERO ROWS.** Even small amounts matter. Don't skip rows with amounts under 1000.

3. **MARK SUBTOTALS.** Identify which rows are sums of other rows and list their components. This helps with reverse engineering later.

4. **NOTE WHICH YEARS ARE ACTUAL vs PROJECTED.** CMA forms often have 2 actual years + 2-3 projected years. Only the ACTUAL years go into our database.

5. **CHECK THE MATH.** Verify that:
   - Component rows sum to subtotal rows
   - Total Assets = Total Liabilities (BS section)
   - Net Sales - Total Cost = Operating Profit (approximately)
   - Flag any mismatches

6. **PRESERVE CMA FIELD NAMES EXACTLY.** Use the exact labels from the CMA form, don't paraphrase.

7. **Look for HIDDEN or MERGED cells.** Excel CMA forms often have merged cells or hidden rows. Check carefully.

## AFTER EXTRACTION

Self-check:
- How many non-zero CMA rows were extracted? (Typical: 50-100 for a manufacturing company)
- Do subtotals add up?
- Is the Balance Sheet section (Current Assets, Current Liabilities, Fixed Assets) complete?
- Are there any CMA rows with amounts but no clear field name? Flag them.

Output the complete JSON. This will be pasted into the main Opus window alongside the financial statements for reverse engineering.
