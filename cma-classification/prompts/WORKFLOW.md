# Ground Truth Extraction Workflow

## Per Company — Step by Step

### STEP 1: Dispatch Subagents (parallel, ~5-10 min each)

**Subagent 2 — CMA Extraction (ALWAYS run this)**
1. Open a fresh Sonnet window
2. Upload the Excel workbook
3. Paste the prompt from `subagent-2-cma-extractor.md`
4. Save output as `{company}_cma.json`

**Subagent 1 — OCR (ONLY if separate PDF exists)**
1. Open another fresh Sonnet window
2. Upload the PDF
3. Paste the prompt from `subagent-1-sonnet-ocr.md`
4. Save output as `{company}_financials.json`

> Both can run at the same time. Start Company B's subagents while Company A's Opus is working.

### STEP 2: Main Opus Window (~20-30 min)

1. Open a **FRESH** Opus context window
2. Upload the Excel workbook
3. Open `main-opus-reverse-engineer.md`
4. Replace the placeholders:
   - `{PASTE_SUBAGENT_2_OUTPUT_HERE}` → paste CMA JSON from Step 1
   - `{PASTE_SUBAGENT_1_OUTPUT_HERE}` → paste OCR JSON (or use Option B)
   - `{industry}`, `{entity_type}`, `{financial_year}` → fill in
5. Paste the complete prompt
6. Let Opus work through all 5 phases

### STEP 3: Validate (~5 min)

Check the output:
- [ ] `unmatched_rows` — should be <5 rows (ideally 0)
- [ ] `validation_issues` — any amount mismatches? Rounding is OK, big differences are NOT
- [ ] `industry_specific_entries` — make sure the industry notes make sense
- [ ] Spot-check 10-15 entries against the original Excel
- [ ] Save as `{company}_ground_truth.json`

### STEP 4: Repeat for all 9 companies

## After All Companies

Run the merge script to combine all JSON files into one database:

```python
import json, glob

all_entries = []
for f in glob.glob("*_ground_truth.json"):
    data = json.load(open(f))
    print(f"{f}: {len(data['database_entries'])} entries, "
          f"{len(data['company_metadata']['unmatched_rows'])} unmatched")
    for entry in data["database_entries"]:
        entry.pop("company_name", None)  # safety: strip company names
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

Expected output: ~2000-4000 entries across 9 companies.

## Time Estimate

| Task | Per Company | Total (9 companies) |
|------|------------|---------------------|
| Subagent 1 (OCR) | 5-10 min | Parallel with Subagent 2 |
| Subagent 2 (CMA) | 5-10 min | Parallel with Subagent 1 |
| Opus (Reverse Eng.) | 20-30 min | Can pipeline |
| Validation | 5 min | 45 min |
| **Total** | **~35-45 min** | **~4-6 hours** |

With pipelining (start next company's subagents while current Opus is running), total wall-clock time is closer to **3-4 hours**.
