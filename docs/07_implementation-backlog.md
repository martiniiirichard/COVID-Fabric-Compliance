# Implementation Backlog

## Objective

Translate design decisions into executable work packages for Bronze/Silver/Gold pipelines, semantic model build, and validation controls.

## Delivery phases

1. Foundation and control plane
2. Data engineering pipelines
3. Semantic model and measures
4. Reporting and trust surfacing
5. Hardening and release readiness

## Work package backlog

## Phase 1: Foundation and control plane

1. `WP-001` Workspace and repo structure
- Scope: confirm `dev/test/prod` workspace topology and artifact folder conventions.
- Owner: Data Platform Lead
- Depends on: none
- Done when:
  - workspaces identified and naming locked
  - artifact path conventions documented

2. `WP-002` Validation framework bootstrap
- Scope: create validation result tables and run metadata schema.
- Owner: Analytics Engineering
- Depends on: `WP-001`
- Done when:
  - validation schema deployed
  - run-level metadata captured (`run_id`, `batch_id`, timestamps, source hash)

3. `WP-003` Continuity protocol operationalization
- Scope: enforce session handoff + daily chat logging workflow.
- Owner: Product/Domain Owner + Codex
- Depends on: none
- Done when:
  - every working session updates log/handoff
  - at least one successful resume from handoff

## Phase 2: Data engineering pipelines

4. `WP-004` Bronze ingestion pipelines
- Scope: ingest all source CSVs with immutable raw snapshots and metadata columns.
- Owner: Data Engineering
- Depends on: `WP-001`
- Done when:
  - all 22 sources ingested
  - ingestion metadata present and queryable

5. `WP-005` Silver conformance for keys and dates
- Scope: standardize `DateKey`, FIPS/state mappings, county/state canonical naming.
- Owner: Analytics Engineering
- Depends on: `WP-004`
- Done when:
  - key conformance success >= 99.0%
  - unmapped keys exception table generated

6. `WP-006` Silver DQ rules (Layer A/B)
- Scope: implement required-column completeness, duplicate grain tests, row drift checks.
- Owner: Analytics Engineering
- Depends on: `WP-005`
- Done when:
  - all Layer A/B rules execute daily
  - threshold breaches produce auditable exceptions

7. `WP-007` Gold marts build
- Scope: publish `mart_compliance_audit`, `mart_spread_risk`, `mart_capacity_pressure`, `mart_policy_effectiveness`.
- Owner: BI + Compliance Analytics
- Depends on: `WP-006`
- Done when:
  - marts refresh successfully
  - lineage path to Silver available

## Phase 3: Semantic model and measures

8. `WP-008` Conformed dimension build
- Scope: implement `DimDate`, `DimGeography`, `DimPolicy`, `DimFacility`, `DimDemographics`.
- Owner: BI Engineering
- Depends on: `WP-007`
- Done when:
  - conformed dims deployed with surrogate keys
  - dimension quality checks pass

9. `WP-009` Fact model build
- Scope: implement `FactEpidemiologyDaily`, `FactHospitalizationDaily`, `FactMobilityDaily`, `FactPolicyEvent`, `FactComplianceAudit`.
- Owner: BI Engineering
- Depends on: `WP-008`
- Done when:
  - relationships follow star-first strategy
  - aggregation consistency checks pass

10. `WP-010` KPI Pack v1 measures
- Scope: implement DAX measures for severity, capacity, policy effectiveness, and trust/audit KPIs.
- Owner: BI Engineering
- Depends on: `WP-009`
- Done when:
  - KPI definitions match `docs/06_kpi-mapping-and-validation-thresholds.md`
  - technical `[AUD]` measures exposed for trust banners

## Phase 4: Reporting and trust surfacing

11. `WP-011` Compliance/audit report pages
- Scope: build report pages aligned to KPI domains with traceable metric definitions.
- Owner: Report Developer
- Depends on: `WP-010`
- Done when:
  - core pages delivered: Severity, Capacity, Policy, Audit/Trust
  - page-level trust state visible

12. `WP-012` Lineage and explainability overlays
- Scope: expose source lineage and metric-definition drill-through paths.
- Owner: BI Engineering
- Depends on: `WP-011`
- Done when:
  - each core KPI has documented lineage link
  - evidence links available in report UX

## Phase 5: Hardening and release readiness

13. `WP-013` Reconciliation and variance pack
- Scope: implement county->state->national reconciliation and variance reporting.
- Owner: Analytics Engineering
- Depends on: `WP-010`
- Done when:
  - monitored totals variance <= 0.5% or exception approved

14. `WP-014` Trust-gate automation
- Scope: assign `T0-T3` status based on validation outcomes and approval metadata.
- Owner: Compliance Analytics
- Depends on: `WP-013`
- Done when:
  - trust gate assigned per KPI domain
  - gate history retained for audit

15. `WP-015` Release signoff package
- Scope: compile audit evidence bundle and residual risk register for first release.
- Owner: Product/Domain Owner
- Depends on: `WP-014`
- Done when:
  - evidence package complete
  - residual risks reviewed and accepted

## Critical path

`WP-001 -> WP-004 -> WP-005 -> WP-006 -> WP-007 -> WP-008 -> WP-009 -> WP-010 -> WP-011 -> WP-013 -> WP-014 -> WP-015`

## Immediate sprint recommendation (strongest next line)

Start Sprint 1 with:

1. `WP-001` Workspace/repo structure lock
2. `WP-004` Bronze ingestion pipelines
3. `WP-005` Silver key/date conformance
4. `WP-006` Layer A/B validation scaffolding

Reason:
- These establish the governed data plane and unblock all downstream semantic/reporting work.

## Acceptance checklist for Sprint 1

- All sources ingest with metadata.
- Date and geography keys standardized for core facts.
- Daily validation run produces pass/fail outputs.
- Exception handling path documented for threshold breaches.

## DEC record

- `DEC-20260511-06`: Approve backlog sequencing and critical path with Sprint 1 focused on ingestion + conformance + validation scaffolding.
