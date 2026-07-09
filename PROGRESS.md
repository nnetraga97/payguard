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

## Open Review Comments

- Before provisioning, reconcile OCI service-limit API output with Always Free billing docs. The CLI reports A1 resource availability, but the official Always Free allowance is the billing guardrail.
- Do not create any OCI resource until the exact instance shape, boot volume size, public IP behavior, and teardown command are documented.
- Keep company-specific role-targeting wording out of committed files.

## Next Action

Draft and review the Phase 0 infrastructure script plan:

1. Determine target compartment and naming convention.
2. Choose a single `VM.Standard.A1.Flex` shape sized at or below the current Always Free allowance.
3. Choose boot volume size that stays inside free-tier storage.
4. Write `infra/oci/provision.sh` and `infra/oci/teardown.sh`.
5. Review the scripts before running them.

## Mentor Questions For The User

- Why does the billing doc matter more than a raw service-limit availability number?
- What resource would most likely break the `$0` constraint first: OCPU, memory, boot volume, public IP, logging, or egress?
- Which Phase 0 services must be always-on, and which can be staged or run only during development?
