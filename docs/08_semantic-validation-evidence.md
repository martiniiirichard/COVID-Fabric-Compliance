# Semantic Validation Evidence

## 2026-05-12 Export Review

Artifact reviewed:

- `data/semantic.vw_trust_gate_status.csv`

## Finding

The exported file name indicates `semantic.vw_trust_gate_status`, but the file contents match `semantic.vw_metric_contracts`.

Observed rows:

- `INCIDENCE_DAILY`
- `MORTALITY_DAILY`
- `HOSPITAL_PRESSURE`
- `MOBILITY_WORKPLACE`
- `TRUST_GATE`

This is valid metric contract evidence, but it is not the trust gate validation snapshot.

## Status

- Metric contract export: captured
- Trust gate status export: captured
- Power BI POC dataset sample export: captured

## Trust Gate Export Review

Artifact reviewed:

- `data/semantic.vw_trust_gate_status.csv`

Observed trust gates:

- `epidemiology`: `T2`, loaded and key checks passed
- `hospitalizations`: `T2`, loaded and key checks passed
- `deaths`: `T0`, `768` null `DateKey` rows
- `mobility`: `T2`, loaded and key checks passed
- `demographics`: `T2`, loaded and key checks passed
- `lawatlas_policy`: `T2`, loaded and key checks passed
- `us_counties_2022`: `T0`, `13,101` null `GeoKey` rows

Interpretation:

- POC semantic layer is operational.
- The validation evidence is not fully clean.
- `deaths` needs date parsing/remediation.
- `us_counties_2022` needs FIPS/GeoKey exception handling.

## Export Quality Note

The reviewed CSV exports appear to be saved without header rows. For audit use, future exports should include column headers.

## Automated Export

Automated script:

- `scripts/export-semantic-evidence.ps1`

Latest automated export:

- `evidence/semantic/SEMANTIC-EVIDENCE-20260512-102534`

Files created:

- `semantic.vw_trust_gate_status.csv` (`7` rows)
- `semantic.vw_metric_contracts.csv` (`5` rows)
- `semantic.vw_powerbi_poc_dataset_top100.csv` (`100` rows)
- `export_manifest.csv`

Result:

- Headers are preserved.
- Export manifest is captured.
- Evidence is stored outside the mutable `data/` staging folder under timestamped run folders.

## T0 Remediation Results

Diagnostic run:

- `evidence/diagnostics/T0-DIAGNOSTICS-20260512-101812`

Remediation scripts:

- `local_dw/sql/12_remediate_t0_trust_gates.sql`
- `local_dw/sql/13_apply_controlled_exception_trust_gate.sql`

Updated trust gate state:

- `epidemiology`: `T2`
- `hospitalizations`: `T2`
- `deaths`: `T1`
- `mobility`: `T2`
- `demographics`: `T2`
- `lawatlas_policy`: `T2`
- `us_counties_2022`: `T2`

Notes:

- `us_counties_2022` `GeoKey` completeness was remediated with controlled `UNK_*` and `SPECIAL_*` geography keys.
- `deaths` monthly rows with valid `year/month` now derive DateKey from year/month.
- `deaths` rows without source year or start date remain a controlled exception and are classified `T1`, not `T2`.

## Required Trust Gate Export Columns

Export this query result from SSMS:

```sql
SELECT *
FROM semantic.vw_trust_gate_status;
```

Expected columns:

- `object_name`
- `row_count`
- `null_datekey_rows`
- `null_geokey_rows`
- `trust_gate`
- `trust_gate_reason`

## Audit Interpretation

The semantic KPI layer executed and produced usable validation evidence. Current state is POC-valid but not audit-ready because two source objects are still `T0`.
