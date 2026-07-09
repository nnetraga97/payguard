# PayGuard Progress

Last updated: 2026-07-09

## Current Phase

Phase 0 / Phase 1 bridge: local-first ML setup while OCI remains unprovisioned.

## Current Milestone

Milestone 1.0: prepare the ML/AI learning runway without implementing the user's ML code.

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
- Added explicit ML/AI ownership rules: the user writes model, feature, evaluation, RAG, and MLOps implementation code; Codex scaffolds and reviews.
- Added local ML workspace setup under `ml/`.
- Added service contracts for `apps/fraud-scorer` and `apps/dispute-assistant` without implementations.
- Added Phase 1 classical fraud scoring task brief, dataset registry, experiment log template, and model card template.
- Added local-only Docker Compose support for Postgres and Redis under `infra/docker/compose.ml.yml`.
- Verified the ML setup branch with `bash -n scripts/setup-ml-env.sh`, `docker compose -f infra/docker/compose.ml.yml config`, `python3` TOML parsing for `ml/pyproject.toml`, `git diff --check`, public-repo scan, and `mvn test`.
- Fixed ML environment setup to choose Python `3.12` or `3.11` instead of an unsupported default `python3` when the default points at Python `3.14`.

## Open Review Comments

- Before provisioning, reconcile OCI service-limit API output with Always Free billing docs. The CLI reports A1 resource availability, but the official Always Free allowance is the billing guardrail.
- Review the Phase 0 script choices before running real provisioning: one `VM.Standard.A1.Flex`, `2` OCPUs, `12` GB memory, `50` GB boot volume, direct public IPv4, SSH limited to caller IP.
- Keep company-specific role-targeting wording out of committed files.

## Next Action

Start Phase 1 classical fraud scoring as user-owned implementation:

1. Read `docs/ml/ml-ai-mentor-contract.md`.
2. Read `docs/ml/phase-1-classical-fraud.md`.
3. Set up the local ML environment with `./scripts/setup-ml-env.sh`.
4. Register the ULB dataset in `docs/ml/dataset-registry.md` without committing data.
5. Create the first user-authored experiment files under `ml/experiments/phase-1-classical-fraud/`.
6. Keep OCI dry-run-only until we have fully reviewed public IPv4 and billing behavior.

## Mentor Questions For The User

- Why does the billing doc matter more than a raw service-limit availability number?
- What resource would most likely break the `$0` constraint first: OCPU, memory, boot volume, public IP, logging, or egress?
- Which Phase 0 services must be always-on, and which can be staged or run only during development?
- Why is accuracy a poor primary metric for fraud detection under extreme class imbalance?
- Which ULB features would be unavailable or suspicious in real-time issuer authorization?
- What is more expensive in your first operating model: a false positive or a false negative, and why?
