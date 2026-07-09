# PayGuard Budget

Last updated: 2026-07-09

## Budget Rule

- OCI must remain `$0`.
- Azure must remain inactive until the Azure sprint entry checklist passes.
- Every cloud resource must have a matching teardown path before creation.

## OCI

Status: authenticated, no project resources created by this repo yet.

Region:

- `us-sanjose-1`

Verified on 2026-07-09:

- OCI CLI version: `3.76.2`
- Region subscription: `us-sanjose-1`, status `READY`
- Availability domain: `dgpj:US-SANJOSE-1-AD-1`
- Official Always Free Ampere A1 allowance: `1,500 OCPU-hours` and `9,000 GB-hours` monthly, equivalent to `2 OCPUs` and `12 GB` for Always Free tenancies.
- Phase 0 dry-run plan: one `VM.Standard.A1.Flex` instance, `2` OCPUs, `12` GB memory, `50` GB boot volume, one public IPv4, SSH CIDR limited to caller IP.
- Dry run completed without creating resources using `PAYGUARD_SSH_PUBLIC_KEY="$HOME/.ssh/astral_oci.pub" ./infra/oci/provision.sh --dry-run`.
- Local-only start chosen after the user reiterated the `$0` constraint. No OCI resources have been created.

Source:

- Oracle Help Center, Always Free Resources: https://docs.oracle.com/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm
- Oracle Cloud Free Tier: https://www.oracle.com/cloud/free/

Notes:

- The OCI service-limit API reports availability values that are not the same thing as the Always Free billing allowance. Treat the official Always Free docs as the billing ceiling.
- Re-check limits before every provisioning session.
- Keep boot volume usage within the free block-storage allowance.

## Azure

Status: not activated for this project.

Rules:

- Do not activate Azure until the entry checklist in `PAYGUARD_PLAN.md` passes.
- Start every Azure session with a cost check.
- Record every spend-relevant action here.
- Teardown before the sprint budget window closes.

Spend:

```text
Date        Service        Action        Estimated Cost        Actual Cost        Notes
----------  -------------  ------------  --------------------  -----------------  -----
```
