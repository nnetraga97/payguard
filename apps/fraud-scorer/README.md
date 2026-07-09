# Fraud Scorer Service

This directory will become the Python FastAPI service for online fraud scoring.

Current status: contract only. The user should implement the service during Phase 1.

## Planned Responsibility

The fraud scorer is the issuer-side real-time decisioning analog for PayGuard. It
will receive authorization features from the Java transaction simulator and return
an explainable risk score plus an operating decision.

## Planned Endpoints

`GET /health`

Returns process health for local and container checks.

`POST /score`

Scores one authorization request.

Planned request shape:

```json
{
  "authorizationId": "auth_123",
  "accountToken": "acct_synthetic_123",
  "amount": "42.17",
  "currency": "USD",
  "merchantCountry": "US",
  "merchantCategoryCode": "5812",
  "channel": "ECOMMERCE",
  "occurredAt": "2026-07-09T18:42:00Z",
  "features": {
    "transactionsLastHour": 1,
    "averageAmountLastDay": 38.22
  }
}
```

Planned response shape:

```json
{
  "authorizationId": "auth_123",
  "modelVersion": "local-baseline",
  "riskScore": 0.12,
  "decision": "APPROVE",
  "reasonCodes": ["LOW_AMOUNT", "KNOWN_COUNTRY"],
  "scoredAt": "2026-07-09T18:42:01Z"
}
```

## Mentor Rule

Codex may help refine this contract and review implementations, but the model
pipeline, feature logic, thresholds, and serving code should be written by the user.
