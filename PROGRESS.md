# PayGuard Progress

Last updated: 2026-07-09

## Current Phase

Phase 0: Skeleton on OCI.

## Current Milestone

Milestone 0.1: prove zero-cost OCI constraints, then scaffold the local repo structure.

## Completed

- Created initial repo operating instructions in `AGENTS.md`.
- Preserved the project roadmap in `PAYGUARD_PLAN.md` with date-specific pacing removed.
- Verified local OCI CLI auth works with OCI CLI `3.76.2`.
- Confirmed tenancy is subscribed to `us-sanjose-1`, status `READY`.
- Confirmed availability domain: `dgpj:US-SANJOSE-1-AD-1`.
- Checked official Oracle Free Tier material on 2026-07-09. Public docs currently state Ampere A1 Always Free as `1,500 OCPU-hours` and `9,000 GB-hours` monthly, equivalent to `2 OCPUs` and `12 GB` for Always Free tenancies.
- Added Phase 0 OCI provision/teardown scripts under `infra/oci/`.
- Added Phase 0 payments and infrastructure notes under `docs/`.
- Ran shell syntax checks for `infra/oci/provision.sh` and `infra/oci/teardown.sh`.
- Ran dry-run verification with `PAYGUARD_SSH_PUBLIC_KEY="$HOME/.ssh/astral_oci.pub" ./infra/oci/provision.sh --dry-run`; no OCI resources were created.
- Started with the no-spend path by leaving OCI unprovisioned and scaffolding the local Spring Boot transaction simulator.
- Added a Maven multi-module root and `apps/transaction-simulator` Spring Boot service with validation, actuator health, and controller tests.
- Ran `mvn test`; 3 tests passed.

## Open Review Comments

- Before provisioning, reconcile OCI service-limit API output with Always Free billing docs. The CLI reports A1 resource availability, but the official Always Free allowance is the billing guardrail.
- Review the Phase 0 script choices before running real provisioning: one `VM.Standard.A1.Flex`, `2` OCPUs, `12` GB memory, `50` GB boot volume, direct public IPv4, SSH limited to caller IP.
- Keep company-specific role-targeting wording out of committed files.

## Next Action

Implement Milestone 0.2 transaction decision rules locally:

1. Read `docs/architecture/milestone-0-2-transaction-decision-rules.md`.
2. Add deterministic authorization decision rules behind `POST /api/authorizations`.
3. Add focused tests for approved, declined, and pending-review outcomes.
4. Run `mvn test`.
5. Keep OCI dry-run-only until we have fully reviewed public IPv4 and billing behavior.

## Mentor Questions For The User

- Why does the billing doc matter more than a raw service-limit availability number?
- What resource would most likely break the `$0` constraint first: OCPU, memory, boot volume, public IP, logging, or egress?
- Which Phase 0 services must be always-on, and which can be staged or run only during development?
