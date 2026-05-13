# Session Handoff

Date: 2026-05-12

## Current State

The COVID Fabric Compliance POC has been cleaned up after user approval.

Active project path: `C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance`

## Cleanup Summary

- Deleted only verified duplicate raw CSV folder: `poc/bronze_raw_subset`.
- Archived excess/debug artifacts to `_archive/2026-05-12-cleanup`.
- Cleanup manifest: `_archive/2026-05-12-cleanup/cleanup_manifest.csv`.
- Cleanup notes: `docs/11_project_cleanup_notes.md`.

## Active SQL Scripts

- `local_dw/sql/00_RESET_RUN_LOCAL_MEDALLION.sql`
- `local_dw/sql/10_create_semantic_kpi_layer.sql`
- `local_dw/sql/11_diagnose_t0_trust_gates.sql`
- `local_dw/sql/12_remediate_t0_trust_gates.sql`
- `local_dw/sql/13_apply_controlled_exception_trust_gate.sql`

## Active Scripts

- `scripts/export-semantic-evidence.ps1`
- `scripts/export-t0-diagnostics.ps1`
- `scripts/new-log-entry.ps1`

## Active Evidence

- `evidence/semantic/SEMANTIC-EVIDENCE-20260512-102534`
- `evidence/diagnostics/T0-DIAGNOSTICS-20260512-101812`

## Next Strong Move

Continue Power BI POC build:

1. Import `Power BI/covid-compliance-audit-theme.json` into `Covid POC.pbip`.
2. Build Executive Overview page from `semantic.vw_powerbi_poc_dataset`, `semantic.vw_trust_gate_status`, and `semantic.vw_metric_contracts`.
3. Validate report measures against SQL evidence exports.

## Git Publish State

- Local Git repo initialized on `main`.
- Initial commit: `f7d4e2b`.
- Remote push pending until GitHub repo `COVID-Fabric-Compliance` exists and an authenticated path is available.
- Raw Bronze CSV files and Power BI cache are intentionally ignored to avoid GitHub large-file rejection.

## Power BI POC Report State

- Page 1 built: `Executive Compliance Overview`.
- Validation command: `pbir validate Power BI\Covid POC.Report --fields --qa`.
- Latest validation passed with no warnings.
- Added explicit measures in TMDL for report visuals.
- Next recommended page: `Data Trust & Audit`.

## 2026-05-13 Design Refresh State

- Expanded Power BI design sample library reviewed from `C:\Users\marti\OneDrive\Desktop\PBI Design Files`.
- Local design skills updated with executive POC design doctrine and sample-library findings.
- COVID report Page 1 refreshed with top header bar, left audit rail, and POC trust-state badge.
- `pbir validate Power BI\Covid POC.Report --fields --qa` passes; only intentional compositing overlap warnings remain.
- Note: `docs/report-preview-executive-overview.svg` remains untracked from the previous static preview and was not staged.

## Landing Page Refinement - 2026-05-13

- Landing page now uses 120px sidebar, page navigator, detail button, compact KPI cards, sparkline companions, and data-through card.
- Added `Data Point Tooltip` and `Compliance Detail` support pages.
- Added semantic measures: `Data Through Date`, `Average Fatality Ratio`.
- Design rule added to local skill: avoid page/visual scrollbars on executive landing pages; move dense content to tooltip/drillthrough/detail pages.
- Structural validation with fields passes. QA warnings remain for intentional compositing and compact cards.

## Landing Page Correction - 2026-05-13

- Current report target: `Power BI\Covid POC.pbip`.
- Executive landing page is now KPI-only above the fold: four KPI cards plus companion sparklines, with lower landing visuals removed.
- Hidden support pages: `Data Point Tooltip` and `Compliance Detail` use PBIR `visibility = HiddenInViewMode`.
- Sidebar uses a compact icon marker and bottom-pinned `Data Through Date` card; no long page navigator is exposed.
- Top-right KPI now answers the peak-case-date question via `Peak New Confirmed Date`, with `Peak New Confirmed` also available for follow-on design.
- Latest validation: `pbir validate Power BI\Covid POC.Report --fields` passed; `--qa` passed with expected compact-card/compositing warnings.
- Keep ignoring/staging separately: `docs/report-preview-executive-overview.svg` remains untracked and unrelated to this report edit.
