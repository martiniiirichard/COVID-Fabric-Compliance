# KPI Mapping and Validation Thresholds (Step 3)

## Goal

Map the first KPI pack to semantic entities and define auditable validation thresholds for trust gating.

## KPI Pack v1 (Compliance + Audit)

1. Epidemiological severity
2. Capacity pressure
3. Policy effectiveness
4. Data trust and reconciliation

## KPI-to-table mapping

### Domain 1: Epidemiological severity

- KPI: `Incidence Rate (7DMA per 100k)`
  - Primary sources: `epidemiology.csv`, `demographics.csv`
  - Semantic entities: `FactEpidemiologyDaily`, `DimGeography`, `DimDate`, `DimDemographics`
- KPI: `Mortality Rate (7DMA per 100k)`
  - Primary sources: `deaths.csv`, `demographics.csv`
  - Semantic entities: `FactEpidemiologyDaily` (or mortality sub-fact), `DimGeography`, `DimDate`
- KPI: `Case Growth WoW`
  - Primary sources: `epidemiology.csv`
  - Semantic entities: `FactEpidemiologyDaily`, `DimDate`

### Domain 2: Capacity pressure

- KPI: `Hospitalization Load Index`
  - Primary source: `hospitalizations.csv`
  - Semantic entities: `FactHospitalizationDaily`, `DimGeography`, `DimDate`
- KPI: `Severe Capacity Alert Rate`
  - Primary sources: `hospitalizations.csv`, `facilities.csv` (contextual)
  - Semantic entities: `FactHospitalizationDaily`, `DimFacility`, `DimDate`

### Domain 3: Policy effectiveness

- KPI: `Policy-On vs Policy-Off Trend Delta`
  - Primary sources: `lawatlas-emergency-declarations.csv`, `epidemiology.csv`, `mobility.csv`
  - Semantic entities: `FactPolicyEvent`, `FactEpidemiologyDaily`, `FactMobilityDaily`, `DimPolicy`, `DimDate`
- KPI: `Mobility Compliance Shift`
  - Primary source: `mobility.csv`
  - Semantic entities: `FactMobilityDaily`, `DimGeography`, `DimDate`

### Domain 4: Data trust and reconciliation

- KPI: `Reconciliation Pass %`
  - Primary sources: Gold marts + validation outputs
  - Semantic entities: `FactComplianceAudit`, technical audit measures
- KPI: `Data Freshness (Hours)`
  - Primary sources: pipeline metadata
  - Semantic entities: technical audit table/measures
- KPI: `Trust Gate Attainment %`
  - Primary sources: trust state registry
  - Semantic entities: `FactComplianceAudit`, trust status dimensions

## Validation threshold framework

## Layer A: Ingestion quality

- Rule A1: Required-column completeness
  - Threshold: `>= 99.5%` non-null for required keys (`date`, `county/state/FIPS`, core measures)
  - Fail condition: below threshold on any critical column
- Rule A2: Batch row-count drift
  - Threshold: `<= +/- 25%` versus trailing 14-day median (unless approved event)
  - Fail condition: drift breach without documented reason
- Rule A3: Duplicate key rate
  - Threshold: `<= 0.1%` duplicate at expected grain (`Date x County` for daily facts)
  - Fail condition: duplicate rate breach

## Layer B: Semantic conformance

- Rule B1: Key conformance success
  - Threshold: `>= 99.0%` successful `GeoKey` + `DateKey` mapping
  - Fail condition: unmapped key share exceeds threshold
- Rule B2: Aggregation consistency
  - Threshold: county->state rollup variance `<= 0.5%` for controlled totals
  - Fail condition: variance breach in monitored totals
- Rule B3: Measure sanity constraints
  - Threshold examples:
    - rates within plausible bounds
    - non-negative counts unless explicitly modeled corrections
  - Fail condition: out-of-bounds values without approved exception

## Layer C: Analytical trust

- Rule C1: Backtest quality (predictive components)
  - Threshold: agreed metric floor (e.g., MAPE cap by use case)
  - Fail condition: below acceptance floor
- Rule C2: Data leakage screen
  - Threshold: zero known leakage features in training set
  - Fail condition: leakage detected

## Layer D: Reporting and governance

- Rule D1: KPI reproducibility
  - Threshold: same query/context returns stable value within tolerance
  - Fail condition: inconsistent reproduction
- Rule D2: Lineage completeness
  - Threshold: 100% lineage path from report KPI to Gold source object
  - Fail condition: missing lineage hop

## Trust gate assignment logic

- `T0 Draft`: one or more Layer A/B controls missing
- `T1 Reviewed`: controls run, but unresolved warnings exist
- `T2 Validated`: all Layer A/B pass + Layer D pass + exceptions documented
- `T3 Audit Ready`: `T2` + formal approval + evidence package archived

## KPI readiness matrix (initial)

- Incidence Rate (7DMA): target `T2`
- Mortality Rate (7DMA): target `T2`
- Hospitalization Load Index: target `T2`
- Policy-On vs Policy-Off Delta: target `T1` initially (causal caveat)
- Reconciliation Pass %: target `T3`
- Trust Gate Attainment %: target `T3`

## Operational cadence

- Daily automated validation run for Layer A/B.
- Post-refresh semantic validation for Layer D.
- Weekly review of exceptions and threshold tuning.

## Risks and controls

- Risk: high-width `google-search-trends.csv` can inflate noise and false drivers.
  - Control: feature whitelist + drift/importance monitoring before KPI use.
- Risk: jurisdiction grain mismatch between policy and county facts.
  - Control: explicit bridge table and documented attribution logic.
- Risk: sampled EDA may miss rare anomalies.
  - Control: full-table targeted checks for keys/measures used in production KPIs.

## DEC record

- `DEC-20260511-05`: Approve KPI Pack v1 and layered threshold model as baseline release criteria for compliance and audit analytics.
