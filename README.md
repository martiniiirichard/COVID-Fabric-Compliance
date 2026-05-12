# COVID Fabric Compliance Analytics

This project is an end-to-end Microsoft Fabric analytics program for legal compliance, auditing, and trusted decision support across descriptive, diagnostic, and predictive use cases.

## Primary outcomes

- Build a validated, auditable analytics product.
- Preserve cross-session continuity as context windows reset.
- Keep all key dialogue, decisions, assumptions, and evidence under version control.

## Structure

- `docs/01_project_charter.md`: Scope, objectives, constraints, and operating model.
- `docs/02_context-continuity-protocol.md`: How Codex continues work across context limits.
- `docs/03_validation-trust-framework.md`: Validation, controls, and trust standards.
- `logs/chat/`: Persisted dialogue logs and session handoff artifacts.
- `data/01_source_inventory.md`: Initial inventory of discovered source files.
- `scripts/new-log-entry.ps1`: Appends standardized chat entries.

## Operating cadence

1. Start each work block by reading:
   - latest `logs/chat/*.md`
   - `logs/chat/session-handoff.md`
   - open decisions in charter and validation docs
2. Make scoped updates.
3. End each block by appending a log entry and refreshing handoff summary.

## Important note

This project is configured for compliant, evidence-based analytics. Any go-to-market or communications workflows should remain accurate, non-deceptive, and aligned with legal/regulatory standards.
