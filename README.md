# AZ-104 MCT Article – Code Snippets

This repository hosts the **public code** referenced in the article *"Cracking AZ-104: Key Concepts and Teaching Tips for MCTs"* by Mohammad Soaeb Rathod. 
It contains Azure CLI, PowerShell, and KQL examples that MCTs can reuse in class demos.

## Contents
- `azure-cli/advanced-vnet-peering-gateway-transit.sh` – Hub/spoke VNets with bidirectional peering, gateway transit, and forwarded traffic.
- `powershell/custom-role-vm-operator.ps1` – Creates a custom role with VM operational permissions and assigns it to a user.
- `kql/failed-signins-geo-anomalies.kql` – KQL query to surface geo-anomalies from failed sign-ins.

## Usage
Clone or download the repo, then:

### Azure CLI
```bash
bash azure-cli/advanced-vnet-peering-gateway-transit.sh           --resource-group rg-network           --hub-location eastus           --spoke-location westus
```
> Requires Azure CLI (`az`) and an existing resource group.

### PowerShell (Az Module)
```powershell
# Install-Module Az -Scope CurrentUser
# Connect-AzAccount
pwsh -File ./powershell/custom-role-vm-operator.ps1 -SubscriptionId <SUBSCRIPTION_ID> -Upn vmoperator@contoso.com
```

### KQL
Paste the contents of `kql/failed-signins-geo-anomalies.kql` into **Log Analytics** or **Microsoft Entra** sign-in logs query experience.

## Link from your article
In your article, reference the files directly, for example:

```markdown
[Azure CLI – Advanced VNet Peering with Gateway Transit](azure-cli/advanced-vnet-peering-gateway-transit.sh)
[PowerShell – Custom Role: Virtual Machine Operator](powershell/custom-role-vm-operator.ps1)
[KQL – Failed Sign-ins with Geographic Anomalies](kql/failed-signins-geo-anomalies.kql)
```

Once you host this repo under your own GitHub account, update the links to the full GitHub URLs.

## License
MIT – see [LICENSE](LICENSE).
