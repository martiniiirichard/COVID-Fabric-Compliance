# Project Cleanup Notes

Date: 2026-05-12

## Goal

Reduce project bloat after midstream SQL Server, medallion, evidence export, and Power BI POC iteration while preserving auditability.

## Kept As Active

- `README.md`
- `docs/01` through `docs/10`
- `local_dw/sql/00_RESET_RUN_LOCAL_MEDALLION.sql`
- `local_dw/sql/10_create_semantic_kpi_layer.sql`
- `local_dw/sql/11_diagnose_t0_trust_gates.sql`
- `local_dw/sql/12_remediate_t0_trust_gates.sql`
- `local_dw/sql/13_apply_controlled_exception_trust_gate.sql`
- `scripts/export-semantic-evidence.ps1`
- `scripts/export-t0-diagnostics.ps1`
- `scripts/new-log-entry.ps1`
- `evidence/semantic/SEMANTIC-EVIDENCE-20260512-102534`
- `evidence/diagnostics/T0-DIAGNOSTICS-20260512-101812`
- `local_dw/layers/bronze`
- `Power BI/` PBIP project and theme file
- `logs/chat/`

## Deleted

- `poc/bronze_raw_subset`

Reason: all seven CSVs were hash-verified exact duplicates of `local_dw/layers/bronze`.

## Archived

Archive location: `_archive/2026-05-12-cleanup`

Archived groups:

- Superseded SQL scripts replaced by the reset and semantic/trust-gate scripts.
- Prototype PowerShell scripts replaced by SQL Server reset and evidence export workflow.
- Manual CSV exports in `data/` replaced by header-preserving evidence exports.
- Earlier semantic evidence runs replaced by `SEMANTIC-EVIDENCE-20260512-102534`.
- Generated local Silver/Gold CSV layer outputs replaced by SQL Server views.

## Manifest

See `_archive/2026-05-12-cleanup/cleanup_manifest.csv` for source, destination, action, and reason for each moved or deleted item.

## Resulting Operating Model

- Active warehouse source files remain in `local_dw/layers/bronze`.
- Active SQL is reduced to five scripts.
- Active automation scripts are reduced to three scripts.
- Latest validated semantic evidence remains in place.
- Historical/debug artifacts are preserved but moved out of the main path.
