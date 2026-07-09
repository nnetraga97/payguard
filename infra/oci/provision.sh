#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

PREFIX="${PAYGUARD_PREFIX:-payguard}"
REGION="${PAYGUARD_REGION:-us-sanjose-1}"
SHAPE="VM.Standard.A1.Flex"
OCPUS="${PAYGUARD_OCPUS:-2}"
MEMORY_GB="${PAYGUARD_MEMORY_GB:-12}"
BOOT_VOLUME_GB="${PAYGUARD_BOOT_VOLUME_GB:-50}"
SSH_PUBLIC_KEY_PATH="${PAYGUARD_SSH_PUBLIC_KEY:-$HOME/.ssh/id_ed25519.pub}"
STATE_FILE="${PAYGUARD_OCI_STATE_FILE:-infra/oci/.payguard-oci-resources.env}"
export OCI_CLI_REGION="$REGION"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require_command oci
require_command curl

if [[ "$OCPUS" != "1" && "$OCPUS" != "2" ]]; then
  echo "Refusing to provision: PAYGUARD_OCPUS must be 1 or 2 for the current Always Free guardrail." >&2
  exit 1
fi

if (( MEMORY_GB < 1 || MEMORY_GB > 12 )); then
  echo "Refusing to provision: PAYGUARD_MEMORY_GB must be between 1 and 12." >&2
  exit 1
fi

if (( BOOT_VOLUME_GB != 50 )); then
  echo "Refusing to provision: Phase 0 boot volume is fixed at 50 GB until BUDGET.md is updated." >&2
  exit 1
fi

if [[ ! -f "$SSH_PUBLIC_KEY_PATH" ]]; then
  echo "Missing SSH public key: $SSH_PUBLIC_KEY_PATH" >&2
  echo "Set PAYGUARD_SSH_PUBLIC_KEY to a public key path before provisioning." >&2
  exit 1
fi

if [[ -f "$STATE_FILE" ]]; then
  echo "State file already exists: $STATE_FILE" >&2
  echo "Run infra/oci/teardown.sh first, or move the state file if this is intentional." >&2
  exit 1
fi

TENANCY_OCID="$(oci iam availability-domain list --all --query 'data[0]."compartment-id"' --raw-output)"
COMPARTMENT_OCID="${PAYGUARD_COMPARTMENT_OCID:-$TENANCY_OCID}"
AVAILABILITY_DOMAIN="${PAYGUARD_AVAILABILITY_DOMAIN:-$(oci iam availability-domain list --all --query 'data[0].name' --raw-output)}"
SSH_CIDR="${PAYGUARD_SSH_CIDR:-$(curl -fsS https://api.ipify.org)/32}"

IMAGE_OCID="$(oci compute image list \
  --compartment-id "$COMPARTMENT_OCID" \
  --shape "$SHAPE" \
  --operating-system 'Canonical Ubuntu' \
  --operating-system-version '24.04' \
  --sort-by TIMECREATED \
  --sort-order DESC \
  --all \
  --query 'data[0].id' \
  --raw-output)"

if [[ -z "$IMAGE_OCID" || "$IMAGE_OCID" == "null" ]]; then
  echo "Could not resolve a Canonical Ubuntu 24.04 ARM image for $SHAPE in $REGION." >&2
  exit 1
fi

cat <<SUMMARY
PayGuard OCI Phase 0 plan

Region:              $REGION
Compartment:         $COMPARTMENT_OCID
Availability domain: $AVAILABILITY_DOMAIN
Shape:               $SHAPE
OCPUs:               $OCPUS
Memory GB:           $MEMORY_GB
Boot volume GB:      $BOOT_VOLUME_GB
Image OCID:          $IMAGE_OCID
SSH public key:      $SSH_PUBLIC_KEY_PATH
SSH CIDR:            $SSH_CIDR
State file:          $STATE_FILE

Resources to create:
- VCN:               $PREFIX-vcn
- Internet gateway:  $PREFIX-ig
- Route table:       $PREFIX-public-rt
- Security list:     $PREFIX-ssh-sl
- Subnet:            $PREFIX-public-subnet
- Instance:          $PREFIX-a1
SUMMARY

if [[ "$DRY_RUN" == "true" ]]; then
  echo
  echo "Dry run only. No OCI resources were created."
  exit 0
fi

mkdir -p "$(dirname "$STATE_FILE")"
SSH_PUBLIC_KEY="$(tr -d '\n' < "$SSH_PUBLIC_KEY_PATH")"

VCN_OCID="$(oci network vcn create \
  --compartment-id "$COMPARTMENT_OCID" \
  --cidr-block '10.42.0.0/16' \
  --display-name "$PREFIX-vcn" \
  --freeform-tags '{"project":"PayGuard","managed-by":"payguard-infra"}' \
  --query 'data.id' \
  --raw-output)"

INTERNET_GATEWAY_OCID="$(oci network internet-gateway create \
  --compartment-id "$COMPARTMENT_OCID" \
  --vcn-id "$VCN_OCID" \
  --is-enabled true \
  --display-name "$PREFIX-ig" \
  --freeform-tags '{"project":"PayGuard","managed-by":"payguard-infra"}' \
  --query 'data.id' \
  --raw-output)"

ROUTE_TABLE_OCID="$(oci network route-table create \
  --compartment-id "$COMPARTMENT_OCID" \
  --vcn-id "$VCN_OCID" \
  --display-name "$PREFIX-public-rt" \
  --route-rules "[{\"cidrBlock\":\"0.0.0.0/0\",\"networkEntityId\":\"$INTERNET_GATEWAY_OCID\"}]" \
  --freeform-tags '{"project":"PayGuard","managed-by":"payguard-infra"}' \
  --query 'data.id' \
  --raw-output)"

SECURITY_LIST_OCID="$(oci network security-list create \
  --compartment-id "$COMPARTMENT_OCID" \
  --vcn-id "$VCN_OCID" \
  --display-name "$PREFIX-ssh-sl" \
  --egress-security-rules '[{"destination":"0.0.0.0/0","protocol":"all"}]' \
  --ingress-security-rules "[{\"source\":\"$SSH_CIDR\",\"protocol\":\"6\",\"tcpOptions\":{\"destinationPortRange\":{\"min\":22,\"max\":22}}}]" \
  --freeform-tags '{"project":"PayGuard","managed-by":"payguard-infra"}' \
  --query 'data.id' \
  --raw-output)"

SUBNET_OCID="$(oci network subnet create \
  --compartment-id "$COMPARTMENT_OCID" \
  --vcn-id "$VCN_OCID" \
  --cidr-block '10.42.1.0/24' \
  --display-name "$PREFIX-public-subnet" \
  --dns-label 'payguard' \
  --route-table-id "$ROUTE_TABLE_OCID" \
  --security-list-ids "[\"$SECURITY_LIST_OCID\"]" \
  --prohibit-public-ip-on-vnic false \
  --freeform-tags '{"project":"PayGuard","managed-by":"payguard-infra"}' \
  --query 'data.id' \
  --raw-output)"

INSTANCE_OCID="$(oci compute instance launch \
  --compartment-id "$COMPARTMENT_OCID" \
  --availability-domain "$AVAILABILITY_DOMAIN" \
  --shape "$SHAPE" \
  --shape-config "{\"ocpus\":$OCPUS,\"memoryInGBs\":$MEMORY_GB}" \
  --subnet-id "$SUBNET_OCID" \
  --image-id "$IMAGE_OCID" \
  --assign-public-ip true \
  --boot-volume-size-in-gbs "$BOOT_VOLUME_GB" \
  --display-name "$PREFIX-a1" \
  --metadata "{\"ssh_authorized_keys\":\"$SSH_PUBLIC_KEY\"}" \
  --freeform-tags '{"project":"PayGuard","managed-by":"payguard-infra"}' \
  --wait-for-state RUNNING \
  --query 'data.id' \
  --raw-output)"

cat > "$STATE_FILE" <<STATE
PAYGUARD_REGION="$REGION"
PAYGUARD_COMPARTMENT_OCID="$COMPARTMENT_OCID"
PAYGUARD_AVAILABILITY_DOMAIN="$AVAILABILITY_DOMAIN"
PAYGUARD_VCN_OCID="$VCN_OCID"
PAYGUARD_INTERNET_GATEWAY_OCID="$INTERNET_GATEWAY_OCID"
PAYGUARD_ROUTE_TABLE_OCID="$ROUTE_TABLE_OCID"
PAYGUARD_SECURITY_LIST_OCID="$SECURITY_LIST_OCID"
PAYGUARD_SUBNET_OCID="$SUBNET_OCID"
PAYGUARD_INSTANCE_OCID="$INSTANCE_OCID"
STATE

echo
echo "Provisioned PayGuard OCI resources."
echo "State file written to $STATE_FILE"
echo "Run ./infra/oci/teardown.sh to delete these resources."
