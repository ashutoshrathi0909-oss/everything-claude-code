# Handoff: CMA Ground Truth Extraction — Review & Next Steps

> **Paste this entire prompt into a new Claude session**, then paste your 7 company summary stats below where indicated.

---

## PROJECT OVERVIEW

We are building a **ground truth database** for an automated CMA (Credit Monitoring Arrangement) classification system. CMA is a standardized financial reporting format used by Indian banks for credit assessment.

**The goal:** Map every financial statement line item (from P&L, Balance Sheet, Notes) to its corresponding CMA form row for 9 Indian companies. This creates training/validation data so a system can automatically classify any company's financial statements into CMA format.

**What we have:**
- 9 company Excel workbooks, each containing CA-certified CMA forms + audited financial statements
- Some companies also have separate PDF financial statements
- A standard CMA template (`CMA_Template.xlsx`) that defines all row numbers and field names

---

## ARCHITECTURE (How Extraction Works)

```
Claude Code Session (Opus — orchestrator)
  │
  ├── Phase 0 (one-time): Parse CMA template → cma_template_reference.json
  │
  └── Phase 1 (per company):
      │
      ├── Step 1: parse_excel.py converts .xlsx → JSON
      │
      ├── Step 2: Two Sonnet subagents run in PARALLEL:
      │   ├── Subagent A (CMA Extractor): Reads parsed Excel + template reference
      │   │   → Extracts every CMA row with amounts for 3 actual years
      │   └── Subagent B (PDF OCR): Only if separate PDF exists
      │       → Extracts P&L, Balance Sheet, Notes, Depreciation Schedule
      │
      ├── Step 3: Opus reverse-engineers the mappings:
      │   - Cross-references CMA rows ↔ financial statement line items
      │   - Handles: direct matches (1→1), composites (N→1), splits (1→N)
      │   - Flags industry-specific placements (manufacturing vs services vs trading)
      │   - Validates all amounts (±1% tolerance for rounding)
      │
      └── Step 4: Saves {company}_ground_truth.json
```

---

## OUTPUT FORMAT

Each company produces a JSON file with this structure:

```json
{
  "company_metadata": {
    "company_name": "...",
    "industry_type": "manufacturing|services|trading",
    "entity_type": "company|llp|proprietorship",
    "financial_year": "2022-23",
    "total_entries": 150,
    "direct_matches": 80,
    "composite_entries": 45,
    "split_entries": 10,
    "unmatched_rows": ["list of CMA rows that couldn't be mapped"],
    "validation_issues": ["any amount mismatches"]
  },
  "database_entries": [
    {
      "raw_text": "Exact text from financial statement",
      "sheet_name": "P&L / Balance Sheet / Notes",
      "section": "Revenue / Expenses / Assets / etc.",
      "note_ref": "Note 15",
      "cma_row": 25,
      "cma_field_name": "Raw Materials Consumed",
      "cma_section": "Cost of Production",
      "amount": 1234567,
      "match_type": "direct | composite_component | split | unmatched",
      "industry_type": "manufacturing",
      "entity_type": "company",
      "financial_year": "2022-23",
      "industry_specific": true,
      "industry_specific_notes": "Manufacturing companies put this under Cost of Production; services companies would put it under Operating Expenses",
      "reasoning": "Why this line item maps to this CMA row"
    }
  ]
}
```

**Match types explained:**
- **direct**: One financial statement line item → one CMA row (e.g., "Revenue from Operations" → CMA Row 1 "Net Sales")
- **composite_component**: Multiple financial items summed into one CMA row (e.g., three expense notes → CMA Row "Other Manufacturing Expenses")
- **split**: One financial item split across multiple CMA rows (e.g., "Depreciation" split between manufacturing and admin)
- **unmatched**: CMA row that couldn't be traced back to financial statements

---

## CURRENT STATUS

**7 out of 9 companies have been extracted.** Summary stats from each company are pasted below.

### >>> PASTE YOUR 7 COMPANY STATS HERE <<<

For each company, paste the `company_metadata` section from its `_ground_truth.json` file. Example format:

```
Company 1: [Company Name]
- Industry: manufacturing
- Entries: 150 | Direct: 80 | Composite: 45 | Split: 10
- Unmatched rows: [list]
- Validation issues: [list]

Company 2: [Company Name]
...
```

**[PASTE BELOW THIS LINE]**




**[END OF COMPANY STATS]**

---

## YOUR TASK

You are a senior Chartered Accountant reviewing this extraction work. Please do the following:

### 1. Quality Review of 7 Completed Companies

For each company's stats:
- **Unmatched count**: Should be <5 per company. Flag any with >5 unmatched rows — these may need re-extraction
- **Match type distribution**: Is the ratio of direct/composite/split reasonable for the industry type? (Manufacturing companies typically have more composites due to cost of production breakdowns)
- **Validation issues**: Any amount mismatches >1% are concerning — flag them
- **Cross-company patterns**: Are similar industries showing similar patterns? Flag any outliers

### 2. Identify Issues & Recommendations

- Which companies (if any) need re-processing or manual review?
- Are there systematic issues (e.g., a CMA row consistently unmatched across companies)?
- Any industry-specific patterns worth noting?

### 3. Plan for Remaining 2 Companies

- What should I watch out for based on patterns from the first 7?
- Any adjustments to the extraction process?

### 4. Merge & Final Database Plan

Once all 9 are done:
- Guide the merge into `ground_truth_database.json`
- Expected total entries (typically 2000-4000 across 9 companies)
- Quality thresholds: overall unmatched rate should be <5%, composite sums should validate

### 5. Summary Report

Produce a table with:
| Company | Industry | Entries | Direct | Composite | Split | Unmatched | Quality |
|---------|----------|---------|--------|-----------|-------|-----------|---------|

And overall stats:
- Total entries across all companies
- Breakdown by match_type
- Number of industry_specific entries
- Overall quality score (% matched)
- Recommendations before using this as training data

---

## IMPORTANT CONTEXT

- **CMA is standardized** — the row numbers and field names are the same across all companies (defined by the template). What varies is which financial statement items map to which rows.
- **Industry matters** — a manufacturing company's CMA has Cost of Production / Cost of Sales sections that services companies don't use. The same expense might go to different CMA rows depending on industry.
- **3 actual years** — each company has 3 years of audited/provisional data (no projections)
- **Exact text preserved** — raw_text fields contain verbatim text from financial documents, never normalized
- **This is ground truth** — accuracy matters more than speed. Better to flag an issue than to miss one.
