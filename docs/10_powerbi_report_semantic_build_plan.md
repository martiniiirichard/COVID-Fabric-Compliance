# Power BI Report and Semantic Build Plan

## Goal

Build the first Power BI POC on top of validated local semantic views, then prepare for Fabric migration.

## Semantic Boundary

Use a thin-report pattern once published to Power BI/Fabric:

- SQL/local POC source: `semantic.vw_powerbi_poc_dataset`
- Trust status source: `semantic.vw_trust_gate_status`
- Metric contract source: `semantic.vw_metric_contracts`

The report should not implement core business logic that belongs in SQL/Silver/Gold.

## Business Processes and Grain

| Process | Fact Type | Grain | Source |
| --- | --- | --- | --- |
| Daily spread monitoring | Periodic snapshot | Date x GeoKey | `semantic.vw_powerbi_poc_dataset` |
| Hospital pressure | Periodic snapshot | Date x GeoKey | `semantic.vw_powerbi_poc_dataset` |
| Mobility signal | Periodic snapshot | Date x GeoKey | `semantic.vw_powerbi_poc_dataset` |
| Trust gate monitoring | Audit snapshot | Object | `semantic.vw_trust_gate_status` |
| Metric contract review | Reference/control | Metric | `semantic.vw_metric_contracts` |

## Candidate Tables for Power BI

- `FactDailyKpi`: from `semantic.vw_powerbi_poc_dataset`
- `FactTrustGate`: from `semantic.vw_trust_gate_status`
- `DimMetricContract`: from `semantic.vw_metric_contracts`
- `DimDate`: generated in Power BI or SQL from `Date`
- `DimGeography`: initial GeoKey-only dimension; enrich later from geography sources

## Starter Measures

- `[New Confirmed] = SUM(FactDailyKpi[NewConfirmed])`
- `[New Deceased] = SUM(FactDailyKpi[NewDeceased])`
- `[Current Hospitalized] = SUM(FactDailyKpi[CurrentHospitalized])`
- `[New Confirmed per 100k] = AVERAGE(FactDailyKpi[NewConfirmedPer100k])`
- `[Daily Fatality Ratio] = DIVIDE([New Deceased], [New Confirmed])`
- `[T2 Object Count] = COUNTROWS(FILTER(FactTrustGate, FactTrustGate[trust_gate] = "T2"))`
- `[Non-T2 Object Count] = COUNTROWS(FILTER(FactTrustGate, FactTrustGate[trust_gate] <> "T2"))`

## Report Pages

### 1. Executive Overview

Question: Is the POC data product healthy enough to support analysis?

Visuals:

- KPI cards: New Confirmed, New Deceased, Current Hospitalized, T2 Object Count
- Daily trend: New Confirmed and New Deceased
- Trust gate status table
- Geography slicer by GeoKey

### 2. Spread and Severity

Question: Where and when are spread/severity signals changing?

Visuals:

- Trend: New Confirmed per 100k
- Trend: Daily Fatality Ratio
- Matrix: GeoKey x latest metrics
- Exception callout for deaths T1 status

### 3. Capacity and Mobility

Question: Do hospital pressure and mobility signals indicate operational risk?

Visuals:

- Trend: Current Hospitalized
- Trend: Current ICU
- Scatter/table: Mobility Workplaces vs New Confirmed
- Hospital pressure band breakdown

### 4. Audit and Trust

Question: Can we defend the data product and explain metric definitions?

Visuals:

- Trust gate matrix
- Metric contract table
- Controlled exception table
- Latest evidence run reference

## Design Rules

- Follow 3-30-300: KPIs first, trends second, evidence/details last.
- Keep page count small for POC.
- Trust state must be visible on every page.
- Use restrained color; reserve warning color for non-T2 trust states.
- Avoid report-level calculations that duplicate SQL metric contracts.

## Theme

Theme file:

- `Power BI/covid-compliance-audit-theme.json`

Theme direction:

- Compliance/audit tone
- Light canvas with restrained teal, amber, green, slate, and red status colors
- Segoe UI typography
- Borders and muted visual chrome pushed into theme defaults
- Red reserved for exceptions/non-T2 trust states

## Done When

- Power BI dataset connects to local SQL views or exported CSVs.
- Theme is imported into `Covid POC.pbip`.
- Starter measures are created and validated against SQL outputs.
- Four POC pages are built.
- Trust state is visible and matches `semantic.vw_trust_gate_status`.
- Evidence package is linked or referenced in the report.

## Next Build Decision

Choose one implementation path:

- Local Power BI Desktop over SQL Server views for fastest POC.
- Fabric Warehouse/Lakehouse migration first, then thin Power BI report.

Recommendation: build local Power BI Desktop POC first, then migrate once page and measure design are proven.
