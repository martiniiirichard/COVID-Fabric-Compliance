# POC Execution Plan

## Goal

Prove the architecture with minimal scope and fast feedback.

## Data subset for POC

- `epidemiology.csv`
- `hospitalizations.csv`
- `deaths.csv`
- `mobility.csv`
- `lawatlas-emergency-declarations.csv`
- `demographics.csv`
- `us-counties-2022.csv`

## Phase plan

1. `POC-01` Bronze subset ingestion
- Output: raw tables + ingestion manifest.

2. `POC-02` Silver conformance
- Output: standardized `DateKey`, `GeoKey`, county/state mappings.

3. `POC-03` Gold marts (thin)
- Output:
  - `mart_spread_risk_poc`
  - `mart_audit_trust_poc`

4. `POC-04` Semantic model (thin)
- Output:
  - conformed dims: `DimDate`, `DimGeography`
  - facts: epidemiology + hospitalization + audit
  - starter KPIs: incidence, mortality, hospitalization load, reconciliation pass %

5. `POC-05` Report and trust banner
- Output: 4 pages + trust state indicator.

## Done when

- One-click refresh path works end-to-end.
- KPI values reproducible across two consecutive runs.
- Layer A/B validation output is generated each run.
- Gaps logged in `POC_GAPS.md`.
