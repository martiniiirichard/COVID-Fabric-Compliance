# POC Validation Package

## Purpose

Package the current local medallion POC evidence into a concise audit-ready summary.

## Active Environment

- Project path: `C:\Users\marti\Documents\Codex\COVID-Fabric-Compliance`
- SQL Server instance: `.\SQLEXPRESS01`
- Database: `CovidMedallionPOC`
- Preferred rebuild script: `local_dw/sql/00_RESET_RUN_LOCAL_MEDALLION.sql`
- Semantic KPI script: `local_dw/sql/10_create_semantic_kpi_layer.sql`

## Evidence Artifacts

- Semantic evidence: `evidence/semantic/SEMANTIC-EVIDENCE-20260512-102534`
- T0 diagnostics: `evidence/diagnostics/T0-DIAGNOSTICS-20260512-101812`
- Validation evidence doc: `docs/08_semantic-validation-evidence.md`

## Current Trust State

| Object | Trust Gate | Notes |
| --- | --- | --- |
| epidemiology | T2 | Loaded and key checks passed |
| hospitalizations | T2 | Loaded and key checks passed |
| mobility | T2 | Loaded and key checks passed |
| demographics | T2 | Loaded and key checks passed |
| lawatlas_policy | T2 | Loaded and key checks passed |
| us_counties_2022 | T2 | Controlled `UNK_*` and `SPECIAL_*` GeoKeys applied |
| deaths | T1 | Remaining DateKey gaps lack source year/start_date and are controlled exceptions |

## Validation Interpretation

The POC is validated enough for report prototyping and semantic model design. It is not yet audit-final because `deaths` remains `T1`.

## Known Limitations

- `deaths` has `113` unresolved date rows that cannot be safely dated from available source fields.
- `us_counties_2022` includes unknown/special geography rows that are preserved with exception keys.
- The Power BI dataset sample export is intentionally sample-first for performance, not a full dataset extract.

## Release Gate

- POC report build: approved to proceed
- Audit-ready release: not approved until `deaths` exception handling is signed off or source gaps are resolved
