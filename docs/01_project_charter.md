# Project Charter

## Goal

Deliver an end-to-end Microsoft Fabric analytics solution for COVID-related legal compliance and auditing use cases, with trusted outputs for executive and operational decisions.

## Problem framing

- We need a product that is usable, defensible, and auditable.
- We need continuity across long-running iterative sessions.
- We need repeatable validation before outputs are treated as decision-grade.

## Scope

- Data ingestion and serving layer design.
- Semantic model design for compliance and audit analytics.
- Report layer for descriptive, diagnostic, and predictive views.
- Governance controls: lineage, quality checks, assumptions, and evidence trails.
- Session continuity controls for Codex collaboration.

## Out of scope (initial)

- Clinical claims generation.
- Any non-compliant or deceptive promotional automation.
- Production deployment automation beyond agreed release gates.

## Decision log conventions

- Decision ID: `DEC-YYYYMMDD-XX`
- Fields: context, options considered, chosen option, tradeoffs, owner, review date.
- Store active decisions in `logs/chat/session-handoff.md` until closed.

## Ownership model

- Product/Domain Owner: user
- Delivery/Automation Copilot: Codex
- Each artifact must include:
  - owner
  - status
  - last updated
  - validation state

## Delivery phases

1. Foundation: protocols, inventory, governance baseline.
2. Data architecture: source mapping, medallion/serving approach.
3. Semantic model: grain, dimensions, measures, compliance entities.
4. Reporting: legal/audit scorecards + exploratory diagnostics.
5. Validation hardening: data quality, reconciliation, scenario tests.
6. Release readiness: runbook, signoff evidence, residual risk register.
