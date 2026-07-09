# Phase 0 Payments Primer

Phase 0 builds the transaction spine. Treat it like a simplified issuer-side authorization path:

1. A cardholder attempts a purchase.
2. A merchant/acquirer sends an authorization request through a network.
3. The issuer evaluates the request for account status, available funds, risk, and policy.
4. The issuer approves, declines, or flags the transaction.
5. Later flows, such as clearing, settlement, disputes, and chargebacks, reconcile money movement and exception handling.

For PayGuard, the first Java service should simulate authorization-like events. It does not need full ISO 8583 fidelity, but the event shape should preserve the concepts that matter later for fraud scoring:

- Transaction amount and currency
- Merchant category
- Merchant country
- Card-present vs card-not-present signal
- Entry mode or channel
- Transaction timestamp
- Synthetic card/account identifier
- Authorization outcome
- Risk or review reason when applicable

Staff-level question: which fields are safe to emit into logs and events, and which must be tokenized or suppressed even when the data is synthetic?
