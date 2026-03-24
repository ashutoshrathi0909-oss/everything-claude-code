# Ground Truth Extraction Workflow — Single Session

## Overview

Run everything from **one Claude Code session** (Opus). Subagents handle mechanical extraction in their own context windows — only compact JSON comes back. Opus keeps its full context free for reverse engineering.

```
YOUR CLAUDE CODE SESSION (Opus)
  │
  ├─→ Sonnet Subagent: CMA Extraction (fresh context, reads Excel via script)
  ├─→ Sonnet Subagent: PDF OCR (fresh context, only if PDF exists)
  │   (both run in PARALLEL)
  │
  └─→ Opus: Reverse engineering (full context, receives subagent JSONs automatically)
      └─→ Saves {company}_ground_truth.json
```

## Prerequisites

1. Open Claude Code in your CMA project folder (where all 9 company files are)
2. Install openpyxl: `pip install openpyxl`
3. Make sure `scripts/parse_excel.py` is in the folder (extracts Excel data as JSON)

## How to Run

### Option A: Process All 9 Companies (Recommended)
Paste the contents of `run-extraction.md` into Claude Code. It will:
1. Scan the folder for company files
2. Process each company one by one
3. For each: dispatch subagents → reverse engineer → save JSON
4. After all 9: merge into `ground_truth_database.json`

### Option B: Process One Company at a Time
Tell Claude Code:
```
Process [company filename].xlsx using the prompts in the prompts/ folder.
Run parse_excel.py first to extract the sheets, then dispatch Sonnet subagents
for CMA extraction (and PDF OCR if a PDF exists for this company).
Then do the Opus reverse engineering and save as {company}_ground_truth.json.
```

## Per-Company Flow (What Happens Automatically)

### Step 1: Parse Excel (~seconds)
```bash
python scripts/parse_excel.py "Company File.xlsx" --output company_sheets.json
```
Converts binary .xlsx → readable JSON that subagents can process.

### Step 2: Dispatch Subagents (parallel, ~2-5 min each)

**Subagent A — CMA Extraction** (always runs)
- Model: Sonnet (via Agent tool)
- Reads the parsed Excel JSON
- Extracts CMA row numbers, field names, amounts
- Returns structured JSON

**Subagent B — PDF OCR** (only if separate PDF exists)
- Model: Sonnet (via Agent tool)
- Reads the PDF using Claude's Read tool
- Extracts P&L, Balance Sheet, Notes, Depreciation Schedule
- Returns structured JSON

Both subagents run in parallel. Neither consumes the main context window.

### Step 3: Opus Reverse Engineering (~10-20 min)
Opus receives both subagent outputs automatically. It:
- Cross-references CMA amounts ↔ financial statement line items
- Handles direct matches, composites (many→one), and splits (one→many)
- Flags industry-specific placements
- Validates all amounts (components must sum to CMA totals)
- Outputs `{company}_ground_truth.json`

### Step 4: Validate (~2 min)
Check the output:
- `unmatched_rows` — should be <5 rows
- `validation_issues` — rounding OK, big mismatches NOT OK
- `industry_specific_entries` — do the notes make sense?
- Spot-check 10-15 entries against the original Excel

## After All 9 Companies

The merge script combines all JSON files:

```python
import json, glob

all_entries = []
for f in glob.glob("*_ground_truth.json"):
    data = json.load(open(f))
    print(f"{f}: {len(data['database_entries'])} entries, "
          f"{len(data['company_metadata']['unmatched_rows'])} unmatched")
    for entry in data["database_entries"]:
        entry.pop("company_name", None)
        all_entries.append(entry)

with open("ground_truth_database.json", "w") as f:
    json.dump(all_entries, f, indent=2)

print(f"\nTotal entries: {len(all_entries)}")
print(f"Direct: {sum(1 for e in all_entries if e['match_type'] == 'direct')}")
print(f"Composite: {sum(1 for e in all_entries if e['match_type'] == 'composite_component')}")
print(f"Split: {sum(1 for e in all_entries if e['match_type'] == 'split')}")
print(f"Unmatched: {sum(1 for e in all_entries if e['match_type'] == 'unmatched')}")
print(f"Industry-specific: {sum(1 for e in all_entries if e.get('industry_specific'))}")
```

Expected: ~2000-4000 entries across 9 companies.

## File Reference

| File | Purpose |
|------|---------|
| `run-extraction.md` | Master prompt — paste this to process all companies |
| `subagent-1-sonnet-ocr.md` | PDF OCR subagent instructions |
| `subagent-2-cma-extractor.md` | CMA extraction subagent instructions |
| `main-opus-reverse-engineer.md` | Opus reverse engineering instructions |
| `scripts/parse_excel.py` | Excel → JSON converter |
