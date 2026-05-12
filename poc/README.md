# POC Track

Purpose: deliver a fast, end-to-end proof of concept before full hardening.

## POC scope

1. Ingest a focused subset of source tables.
2. Build minimal Silver conformance for date + geography keys.
3. Publish 2 Gold outputs:
   - spread/severity
   - audit/trust
4. Build a thin semantic model with KPI Pack starter measures.
5. Deliver one report page per domain:
   - Severity
   - Capacity
   - Policy
   - Audit/Trust

## POC success criteria

- End-to-end refresh works on schedule.
- Core KPIs render correctly with traceable lineage.
- Trust banner displays validation status.
- Known gaps captured in a remediation log.

## Out of scope for POC

- Full predictive modeling hardening
- Complete exception catalog
- Finalized T3 audit package
