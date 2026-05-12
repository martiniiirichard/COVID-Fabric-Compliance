# SSMS Run Order (SQLEXPRESS)

Target instance: `.\SQLEXPRESS01`

## 1) Create DB + schemas

Run:
- `local_dw/sql/00_create_database_and_schemas.sql`

## 2) Create Bronze tables

Run:
- `local_dw/sql/01_create_bronze_tables.sql`

## 3) Load Bronze data

Run:
- `local_dw/sql/05_bulk_load_templates.sql`

If `BULK INSERT` fails due to permissions:
- Move CSVs to a SQL Server service-readable folder (for example `C:\Temp\covid\`)
- Update file paths in `05_bulk_load_templates.sql`
- Re-run

## 4) Create Silver views

Run:
- `local_dw/sql/02_create_silver_views.sql`

## 5) Create Gold views

Run:
- `local_dw/sql/03_create_gold_views.sql`

## 6) Validate

Run:
- `local_dw/sql/04_validation_queries.sql`

## Expected POC outputs

- `gold.vw_spread_risk_daily`
- `gold.vw_audit_trust`
- `semantic.vw_daily_kpi_summary`
- `semantic.vw_trust_gate_status`
- `semantic.vw_powerbi_poc_dataset`
- `semantic.vw_metric_contracts`

## Current simplified run order

Run:

- `local_dw/sql/00_RESET_RUN_LOCAL_MEDALLION.sql`
- `local_dw/sql/10_create_semantic_kpi_layer.sql`
- `scripts/export-semantic-evidence.ps1 -ServerInstance ".\SQLEXPRESS01"`

## Migration note

These layers map directly to Fabric medallion:
- `bronze.*` -> Lakehouse Bronze tables
- `silver.vw_*` -> Silver transformations (Notebook/SQL endpoint)
- `gold.vw_*` -> Gold marts for semantic model/reporting
- `semantic.vw_*` -> Power BI semantic model input views and metric contracts
