# Context Continuity Protocol

## Purpose

Preserve project memory and execution continuity as chat context windows roll over.

## Protocol components

1. Dialogue log (`logs/chat/YYYY-MM-DD.md`)
2. Session handoff (`logs/chat/session-handoff.md`)
3. Decision register (active decisions embedded in handoff)
4. Next-prompt bootstrap block (copy/paste starter for next session)

## Mandatory end-of-session checklist

1. Append a chat entry using `scripts/new-log-entry.ps1`.
2. Update `session-handoff.md`:
   - current objective
   - what changed
   - pending blockers
   - next strongest move
   - active assumptions/risks
3. Add/close decision IDs.
4. Record validation status for modified artifacts.

## Session bootstrap protocol

At start of new session:

1. Read newest daily chat log.
2. Read `session-handoff.md`.
3. Confirm current objective and immediate next move.
4. Continue execution without re-discovery unless assumptions changed.

## Bootstrap prompt template

Use this at the top of any resumed session:

```text
Resume project from:
1) logs/chat/session-handoff.md
2) latest logs/chat/YYYY-MM-DD.md
3) docs/01_project_charter.md and docs/03_validation-trust-framework.md

Execute the "Next Strongest Move" first. Preserve existing decisions unless explicitly superseded with a new DEC id and tradeoff note.
```

## Git protocol for logs

- Commit logs in small increments with work artifacts.
- Never rewrite prior log history.
- If sensitive text appears, redact in a follow-up commit with rationale; do not force-push history.
