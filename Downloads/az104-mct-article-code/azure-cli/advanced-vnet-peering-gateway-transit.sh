#!/usr/bin/env bash
set -euo pipefail

# Parameters with defaults (override via flags)
RG="rg-network"
HUB_LOCATION="eastus"
SPOKE_LOCATION="westus"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --resource-group) RG="$2"; shift 2;;
    --hub-location) HUB_LOCATION="$2"; shift 2;;
    --spoke-location) SPOKE_LOCATION="$2"; shift 2;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

echo "Using RG=$RG HUB_LOCATION=$HUB_LOCATION SPOKE_LOCATION=$SPOKE_LOCATION"

# Create hub VNet and gateway subnet
az network vnet create -g "$RG" -n vnet-hub --address-prefix 10.0.0.0/16           --subnet-name snet-hub --subnet-prefix 10.0.1.0/24 --location "$HUB_LOCATION"

az network vnet subnet create -g "$RG" --vnet-name vnet-hub           -n GatewaySubnet --address-prefix 10.0.0.0/27

# Create spoke VNet
az network vnet create -g "$RG" -n vnet-spoke --address-prefix 10.1.0.0/16           --subnet-name snet-spoke --subnet-prefix 10.1.1.0/24 --location "$SPOKE_LOCATION"

# Establish bi-directional peering with gateway transit
az network vnet peering create -g "$RG" --vnet-name vnet-hub -n hub-to-spoke           --remote-vnet vnet-spoke --allow-vnet-access --allow-gateway-transit --allow-forwarded-traffic

az network vnet peering create -g "$RG" --vnet-name vnet-spoke -n spoke-to-hub           --remote-vnet vnet-hub --allow-vnet-access --use-remote-gateways --allow-forwarded-traffic

echo "Completed hub-spoke peering with gateway transit."
