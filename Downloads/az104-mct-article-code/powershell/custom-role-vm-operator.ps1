param(
  [Parameter(Mandatory=$true)][string]$SubscriptionId,
  [Parameter(Mandatory=$true)][string]$Upn,
  [string]$RoleName = "Virtual Machine Operator"
)

#Requires -Modules Az.Accounts, Az.Resources

Write-Host "Connecting to Azure..."
try { Connect-AzAccount -ErrorAction Stop | Out-Null } catch {}
Select-AzSubscription -Subscription $SubscriptionId -ErrorAction Stop

$roleDef = @{
  Name            = $RoleName
  IsCustom        = $true
  Description     = 'Can monitor, start, stop, and restart virtual machines'
  Actions         = @(
    'Microsoft.Compute/virtualMachines/read',
    'Microsoft.Compute/virtualMachines/start/action',
    'Microsoft.Compute/virtualMachines/restart/action',
    'Microsoft.Compute/virtualMachines/deallocate/action',
    'Microsoft.Insights/metrics/read'
  )
  NotActions      = @('Microsoft.Compute/virtualMachines/delete')
  DataActions     = @()
  NotDataActions  = @()
  AssignableScopes= @("/subscriptions/$SubscriptionId")
} | ConvertTo-Json -Depth 10

$tmp = [System.IO.Path]::GetTempFileName()
Set-Content -Path $tmp -Value $roleDef -Encoding utf8

try {
  New-AzRoleDefinition -InputFile $tmp -ErrorAction Stop | Out-Null
  Write-Host "Custom role '$RoleName' created."
} catch {
  if ($_.Exception.Message -match 'already exists') {
    Write-Host "Custom role '$RoleName' already exists."
  } else { throw }
}

$user = Get-AzADUser -UserPrincipalName $Upn -ErrorAction Stop
New-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionName $RoleName -Scope "/subscriptions/$SubscriptionId" -ErrorAction Stop | Out-Null
Write-Host "Assigned '$RoleName' to $Upn at subscription scope."
