#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${PAYGUARD_OCI_STATE_FILE:-infra/oci/.payguard-oci-resources.env}"

if [[ ! -f "$STATE_FILE" ]]; then
  echo "Missing state file: $STATE_FILE" >&2
  echo "Nothing was deleted." >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$STATE_FILE"
export OCI_CLI_REGION="${PAYGUARD_REGION:-us-sanjose-1}"

delete_if_set() {
  local label="$1"
  local ocid="$2"
  shift 2

  if [[ -z "$ocid" ]]; then
    echo "Skipping $label: no OCID recorded."
    return
  fi

  echo "Deleting $label: $ocid"
  "$@" || echo "Warning: failed to delete $label. Inspect OCI console/CLI before removing $STATE_FILE." >&2
}

if [[ -n "${PAYGUARD_INSTANCE_OCID:-}" ]]; then
  echo "Terminating instance: $PAYGUARD_INSTANCE_OCID"
  oci compute instance terminate \
    --instance-id "$PAYGUARD_INSTANCE_OCID" \
    --force \
    --wait-for-state TERMINATED
fi

delete_if_set "subnet" "${PAYGUARD_SUBNET_OCID:-}" \
  oci network subnet delete --subnet-id "${PAYGUARD_SUBNET_OCID:-}" --force

delete_if_set "security list" "${PAYGUARD_SECURITY_LIST_OCID:-}" \
  oci network security-list delete --security-list-id "${PAYGUARD_SECURITY_LIST_OCID:-}" --force

delete_if_set "route table" "${PAYGUARD_ROUTE_TABLE_OCID:-}" \
  oci network route-table delete --rt-id "${PAYGUARD_ROUTE_TABLE_OCID:-}" --force

delete_if_set "internet gateway" "${PAYGUARD_INTERNET_GATEWAY_OCID:-}" \
  oci network internet-gateway delete --ig-id "${PAYGUARD_INTERNET_GATEWAY_OCID:-}" --force

delete_if_set "VCN" "${PAYGUARD_VCN_OCID:-}" \
  oci network vcn delete --vcn-id "${PAYGUARD_VCN_OCID:-}" --force

rm -f "$STATE_FILE"
echo "Teardown complete. Removed $STATE_FILE"
