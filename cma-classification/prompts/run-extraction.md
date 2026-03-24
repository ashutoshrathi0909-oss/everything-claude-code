# Master Prompt: Build Ground Truth Database

> **Paste this entire file into your Claude Code session** (opened in your CMA project folder).
> Claude will process all company files automatically.

---

## INSTRUCTIONS FOR CLAUDE

You are building a **ground truth database** for CMA (Credit Monitoring Arrangement) classification. This folder contains Excel workbooks (and possibly PDFs) for 9 companies, each with CA-certified CMA forms and financial statements.

### YOUR GOAL

For each company file, extract every mapping between financial statement line items and CMA rows. Save each company's output as `{company}_ground_truth.json`, then merge all into `ground_truth_database.json`.

### STEP-BY-STEP PROCESS

#### Phase 0: Setup + Template Parsing (runs ONCE)

1. Run `pip install openpyxl` if not already installed
2. List all `.xlsx` and `.pdf` files in this folder to identify the 9 companies and the CMA template file
3. Read `prompts/subagent-1-sonnet-ocr.md`, `prompts/subagent-2-cma-extractor.md`, and `prompts/main-opus-reverse-engineer.md` — these contain the detailed instructions for each step

**Parse the CMA template (one-time)**:
```bash
python scripts/parse_excel.py "CMA_Template.xlsx" --output cma_template_parsed.json
```
Then dispatch a Sonnet subagent to analyze the parsed template:
- **Subagent (Template Analyzer)**: Use the Agent tool with `model: "sonnet"`. In the prompt, include:
  - The parsed template JSON
  - Ask it to produce a `cma_template_reference.json` with every CMA row number, field name, section, whether it's a subtotal, and what rows feed into it
  - Save the output as `cma_template_reference.json`

This reference is reused for ALL 9 companies — never re-parsed.

#### Phase 1: Process Each Company

For each company Excel file:

**Step 1: Parse the Excel file**
```bash
python scripts/parse_excel.py "Company File.xlsx" --output temp_company_sheets.json
```
This converts the binary Excel into readable JSON.

**Step 2: Dispatch subagents (use Agent tool, run in PARALLEL)**

Launch both subagents in a single message:

- **Subagent A (CMA Extraction)**: Use the Agent tool with `model: "sonnet"`. In the prompt, include:
  - The full instructions from `prompts/subagent-2-cma-extractor.md`
  - The `cma_template_reference.json` (from Phase 0) — this is the row reference
  - The parsed company Excel JSON data (from Step 1)
  - Ask it to return the CMA extraction as JSON

- **Subagent B (PDF OCR)**: ONLY if a separate PDF file exists for this company. Use the Agent tool with `model: "sonnet"`. In the prompt, include:
  - The full instructions from `prompts/subagent-1-sonnet-ocr.md`
  - Tell it to read the PDF file using the Read tool
  - Ask it to return the financial statements as JSON

Both subagents get fresh context windows. They don't consume your main context.

**Step 3: Reverse Engineering (YOU do this — full Opus reasoning)**

Once both subagents return their results:
- You now have: CMA extraction JSON + financial statements JSON (from subagent or from Excel sheets)
- Follow the detailed instructions in `prompts/main-opus-reverse-engineer.md`
- Cross-reference every CMA row with the financial statements
- Handle all three cases: direct matches, composites, and splits
- Flag industry-specific placements
- Validate all amounts

**Step 4: Save output**
Save the result as `{company_name}_ground_truth.json` using the Write tool.

**Step 5: Validate**
Quick checks:
- Are there <5 unmatched rows?
- Do composite components sum to CMA row totals?
- Are industry_specific flags reasonable?

Then move to the next company.

#### Phase 2: Merge All Companies

After all 9 companies are processed, run the merge:

```python
import json, glob

all_entries = []
for f in sorted(glob.glob("*_ground_truth.json")):
    data = json.load(open(f))
    count = len(data["database_entries"])
    unmatched = len(data["company_metadata"]["unmatched_rows"])
    print(f"{f}: {count} entries, {unmatched} unmatched")
    for entry in data["database_entries"]:
        entry.pop("company_name", None)
        all_entries.append(entry)

with open("ground_truth_database.json", "w") as f:
    json.dump(all_entries, f, indent=2)

print(f"\nTotal entries: {len(all_entries)}")
```

#### Phase 3: Summary Report

After merging, print a summary:
- Total entries per company
- Breakdown by match_type (direct/composite/split/unmatched)
- Number of industry_specific entries
- Any companies with high unmatched counts (>10%)
- Total database size

### IMPORTANT NOTES

1. **Process one company at a time** — don't try to parallel all 9 companies. Subagents within one company CAN run in parallel.
2. **Preserve exact text** from financial documents — never normalize or clean descriptions.
3. **Validate amounts** — composite components MUST sum to CMA row totals (±1% for rounding).
4. **Flag industry-specific items** — these are the most valuable entries for the classification system.
5. **Don't skip small amounts** — every non-zero CMA row matters.
6. **Save after each company** — don't lose work if context gets long.

### BEGIN

Start by listing all company files in this folder, then process Company 1.
