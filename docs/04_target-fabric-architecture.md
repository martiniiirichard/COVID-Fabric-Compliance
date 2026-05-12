# Target Fabric Architecture Blueprint

## Goal

Define the end-to-end Microsoft Fabric architecture for compliant, auditable COVID analytics with clear layer contracts and operational ownership.

## Architecture decision

- Pattern: Medallion (`Bronze -> Silver -> Gold`) with a governed serving layer for semantic modeling and reporting.
- Storage: OneLake-backed Lakehouse zones with Delta tables.
- Consumption: Power BI semantic model on curated Gold + compliance marts.

## Workspace topology

1. `covid-dev`: engineering and model development.
2. `covid-test`: validation, reconciliation, and UAT.
3. `covid-prod`: controlled release and audited consumption.

Use deployment pipelines to promote artifacts and preserve traceability.

## Layer design

### Bronze (Raw Ingestion)

Purpose:
- Land source files as immutable raw snapshots.

Sources:
- `epidemiology.csv`, `deaths.csv`, `hospitalizations.csv`, `health.csv`
- `mobility.csv`, `mask-use-by-county.csv`, `lawatlas-emergency-declarations.csv`
- `demographics.csv`, `economy.csv`, geography and county/state files

Rules:
- No destructive transforms.
- Add ingestion metadata: `ingest_ts`, `source_file`, `source_hash`, `batch_id`.
- Retain raw schema drift details in audit columns.

Owner:
- Data Engineering

### Silver (Conformed and Quality-Controlled)

Purpose:
- Standardize keys, dates, and entities; apply data quality gates.

Core entities:
- `dim_date`, `dim_geography`, `dim_policy`, `dim_facility`, `dim_demographics`
- `fact_epidemiology_daily`, `fact_hospitalization_daily`, `fact_mobility_daily`

Rules:
- Conform grain to daily x county (or documented exception).
- Resolve key strategy:
  - `geo_key` (FIPS + state normalization)
  - `date_key` (YYYYMMDD)
- Apply DQ checks with pass/fail status written to validation tables.

Owner:
- Analytics Engineering

### Gold (Business and Compliance Marts)

Purpose:
- Publish decision-grade, audit-aligned data products for semantic model and legal reporting.

Data products:
- `mart_compliance_audit`
- `mart_spread_risk`
- `mart_capacity_pressure`
- `mart_policy_effectiveness`

Rules:
- Include lineage fields to Silver source rows/batches.
- Include trust gate status (`T0`-`T3`) per mart build.
- Persist reconciliation metrics and approval metadata.

Owner:
- BI + Compliance Analytics

## Serving layer contract

Serving objects (SQL endpoint/Warehouse views):
- `vw_compliance_events`
- `vw_daily_county_status`
- `vw_policy_impact_baseline`
- `vw_capacity_alerts`

Contract requirements:
- Stable column names and data types.
- Documented refresh SLA and late-arrival behavior.
- Versioned schema changes with deprecation windows.
- Row-level access strategy by audience (if needed).

## Semantic model boundary

Model inputs:
- Gold marts and serving views only.

Model responsibilities:
- Measures, time intelligence, conformed dimensions, KPI readiness flags.

Model exclusions:
- Raw cleansing logic and non-curated joins.

## Governance and controls

Mandatory controls:
1. Data lineage enabled from source to report.
2. Validation results persisted and queryable.
3. Change log for transformations and business rules.
4. Release gate requiring trust state and approver.

Security:
- Least privilege by workspace role.
- Separate build/write roles from read/consumer roles.

## Refresh and orchestration

Orchestration pattern:
1. Ingest raw files to Bronze.
2. Run Silver conformance and DQ.
3. Build Gold marts.
4. Reconcile and publish validation evidence.
5. Refresh semantic model.
6. Mark trust gate and release status.

Scheduling:
- Daily primary cadence; support ad hoc reruns with batch IDs.

## Audit evidence outputs

For each production run, persist:
- Run ID and timestamps
- Input file hashes and row counts
- DQ results and threshold exceptions
- Reconciliation summary
- Approver/signoff metadata

## Ownership matrix

- Data ingestion reliability: Data Engineering
- Conformance and DQ: Analytics Engineering
- Semantic model quality: BI Engineering
- Compliance interpretation: Compliance Owner
- Release approval: Product/Domain Owner

## DEC record

- `DEC-20260511-03`: Adopt medallion + governed serving layer with trust-gated Gold marts as system-of-record for semantic/reporting.
