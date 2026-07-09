# Milestone 0.2: Transaction Decision Rules

## Goal

Implement the first deterministic authorization decision rules in the transaction simulator.

This is the first user-implementation milestone. The scaffold already accepts a synthetic authorization request and returns `PENDING_REVIEW`. Replace that placeholder with rules you can defend.

## Suggested Rules

Start simple:

- Approve normal low-risk transactions.
- Decline impossible or unsupported transactions.
- Mark high-risk-but-not-impossible transactions as `PENDING_REVIEW`.

Good candidate signals:

- Amount
- Merchant country
- Merchant category code
- Channel
- Transaction timestamp

## Constraints

- Do not log full account tokens.
- Keep `cardLastFour` only for display/debug convenience; do not treat it as an identity key.
- Keep the logic deterministic for now so tests are crisp.
- Add tests before or alongside the implementation.

## Staff Review Prompts

- Which decisions map to issuer real-time authorization?
- Which rules are fraud/risk policy, and which are payment validity checks?
- What breaks if these thresholds are hard-coded in a real issuer system?
- What information is missing from this request to make a production-grade risk decision?
