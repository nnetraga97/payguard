# OCI Phase 0 Infrastructure

These scripts prepare the first PayGuard Always Free VM on OCI. They are intentionally conservative.

## Current Guardrail

Verified on 2026-07-09 from Oracle's public Free Tier docs:

- Shape: `VM.Standard.A1.Flex`
- Maximum Always Free planning ceiling: `2 OCPUs`, `12 GB` memory
- Monthly allowance: `1,500 OCPU-hours`, `9,000 GB-hours`

The initial PayGuard VM uses exactly:

- `2` OCPUs
- `12` GB memory
- `50` GB boot volume
- One public IPv4 address assigned directly to the VM
- SSH ingress limited to the caller's current public IP by default

Do not increase these values without updating `BUDGET.md` and rechecking official pricing/free-tier docs.

## Review Before Running

The provision script creates:

- One VCN
- One internet gateway
- One route table
- One security list
- One public subnet
- One `VM.Standard.A1.Flex` instance

The teardown script deletes those resources using the local state file:

```text
infra/oci/.payguard-oci-resources.env
```

That file is ignored by git because it is environment-specific.

## Usage

Preview the configuration:

```bash
./infra/oci/provision.sh --dry-run
```

Provision after review:

```bash
./infra/oci/provision.sh
```

Tear down:

```bash
./infra/oci/teardown.sh
```

Optional environment variables:

```bash
PAYGUARD_COMPARTMENT_OCID=ocid1.compartment...
PAYGUARD_SSH_PUBLIC_KEY="$HOME/.ssh/id_ed25519.pub"
PAYGUARD_SSH_CIDR="203.0.113.10/32"
PAYGUARD_PREFIX="payguard"
```

If `PAYGUARD_COMPARTMENT_OCID` is not set, the scripts use the tenancy root compartment reported by the OCI CLI.
