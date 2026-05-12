# Semantic Model Grain and Conformed Dimensions

## Goal

Define a stable semantic model blueprint with explicit grain, conformed dimensions, and measure domains for compliance and audit reporting.

## Primary grain decision

- Canonical analytical grain: `Date x County`.
- Secondary rollup grain: `Date x State`.
- Exception grain: policy events (`EffectiveDate x Jurisdiction`) with bridge logic.

Decision:
- `DEC-20260511-04`: Use `Date x County` as primary grain to preserve diagnostic depth and support audited aggregation.

## Model boundary

Inputs:
- Gold marts and governed serving views only.

Excluded:
- Bronze/Silver raw logic.
- Direct file-to-model joins.

## Conformed dimensions

### `DimDate`

Key:
- `DateKey` (int YYYYMMDD)

Attributes:
- full date, week, month, quarter, year, fiscal variants, day-of-week

Use:
- Single conformed time axis for all daily facts.

### `DimGeography`

Key:
- `GeoKey` (surrogate)

Natural keys:
- `CountyFIPS`, `StateCode`

Attributes:
- county, state, region, population bands, urban/rural class (if available)

Use:
- Cross-domain join anchor for epidemiology, capacity, mobility, and policy exposure.

### `DimPolicy`

Key:
- `PolicyKey` (surrogate)

Attributes:
- policy type, declaration status, start date, end date, jurisdiction level, legal source

Use:
- Policy effectiveness and compliance slicing.

### `DimFacility`

Key:
- `FacilityKey`

Attributes:
- facility type, location geo linkage, capacity category

Use:
- Capacity and access diagnostics.

### `DimDemographics`

Key:
- `DemographicKey`

Attributes:
- age bands, socioeconomic tiers, vulnerability markers (as available)

Use:
- Equity and risk segmentation.

## Fact tables (semantic-facing)

### `FactEpidemiologyDaily`

Grain:
- `DateKey, GeoKey`

Measures:
- cases, deaths, case growth rate, death growth rate, rolling averages

### `FactHospitalizationDaily`

Grain:
- `DateKey, GeoKey`

Measures:
- hospital admissions, occupied beds, ICU pressure, utilization rate

### `FactMobilityDaily`

Grain:
- `DateKey, GeoKey`

Measures:
- mobility index, change vs baseline

### `FactPolicyEvent`

Grain:
- `PolicyEffectiveDateKey, Jurisdiction`

Measures:
- policy active flag, days active, policy overlap counts

Note:
- Use geography bridge/mapping for county-level attribution when policy is state-level.

### `FactComplianceAudit`

Grain:
- `DateKey, GeoKey, RuleKey` (or rule domain)

Measures:
- rule pass/fail, variance values, reconciliation deltas, trust gate status code

## Relationship strategy

- Star-first, one-to-many from conformed dims to facts.
- No many-to-many unless explicitly documented and isolated behind bridge tables.
- Single-direction filters by default; bidirectional only with explicit test evidence.

## KPI domains and measure groups

1. Spread and severity
   - incidence rate
   - Rt proxy (if modeled)
   - severe outcome ratios
2. Capacity and pressure
   - hospitalization load
   - ICU stress indicators
   - facility strain index
3. Policy and behavior effectiveness
   - policy-on vs policy-off trend deltas
   - mobility compliance signals
4. Compliance and audit integrity
   - reconciliation pass rate
   - stale data flags
   - trust gate attainment

## DAX design standards

- Use base measures + derived measures pattern.
- Keep semi-additive logic explicit for snapshot metrics.
- Isolate complex logic in named measure families:
  - `[EPI]`
  - `[CAP]`
  - `[POL]`
  - `[AUD]`

Naming convention example:
- `[EPI] Cases`
- `[EPI] Cases 7DMA`
- `[AUD] Reconciliation Pass %`

## Calculation groups (recommended)

- Time intelligence group:
  - MTD, QTD, YTD, rolling 7/28 day
- Scenario group (future):
  - baseline, conservative, stress

## RLS/OLS strategy (initial)

- RLS optional unless audience segmentation requires jurisdiction scoping.
- OLS reserved for sensitive fields in compliance evidence marts.

## Validation hooks in model

Add semantic-facing technical measures:
- `[AUD] Data Freshness (Hours)`
- `[AUD] Trust Gate Code`
- `[AUD] Reconciliation Delta`
- `[AUD] Validation Status Text`

These appear in hidden technical table and drive report trust banners.

## Open modeling risks

- Mixed county/state policy grains can bias causal interpretation without careful bridge design.
- Missing county identifiers in some files may require controlled imputation or exclusion.
- Predictive features must be isolated from leakage-prone post-outcome variables.

## Implementation sequence

1. Build conformed `DimDate` and `DimGeography`.
2. Land `FactEpidemiologyDaily` and `FactHospitalizationDaily`.
3. Add policy and mobility facts with bridge tables.
4. Add compliance audit fact and trust metrics.
5. Validate aggregation consistency county -> state -> national.
