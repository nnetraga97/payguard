# Phase 0 Infrastructure Notes

## Decision

Start with one OCI `VM.Standard.A1.Flex` instance sized at `2 OCPUs` and `12 GB` memory, plus a `50 GB` boot volume.

## Rationale

This stays inside the current official Always Free planning ceiling and forces the architecture to respect a realistic small-host budget. PayGuard can still run meaningful local and always-on slices by staging services instead of pretending every future component must be resident all the time.

## Initial Always-On Candidate

The first always-on slice should be small:

- Java transaction simulator/API
- Postgres
- Redis
- One broker process, only if memory measurements support it

Everything else can remain local, batch, or manually started until there is evidence it needs to be always-on.

## Risk Register

- OCI service-limit availability is not the same as Always Free billing eligibility.
- Boot volume growth can quietly consume the free storage allowance.
- Public IPv4, logging, monitoring, and egress should be checked before enabling extras.
- Kafka may be too memory-hungry for the final always-on box; Redpanda or staged broker usage remains an option.

## Open Review Question

Before provisioning, defend why one larger A1 VM is better than splitting the allowance across smaller VMs for Phase 0.
