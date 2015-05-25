$tfsvm="tfs2015preivew"
$tfsstorage='tfs2015preview'
$tfsservice='tfs2015preview'
$tfslocation='East Asia'
$tfsadmin='tfsadmin'
$tfsadminpwd='P2ssw0rd'

# The script has been tested on Powershell 3.0
Set-StrictMode -Version 3

# Set the output level to verbose and make the script stop on error
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

# Grant administrative privileges
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Verbose "Script is not run with administrative user"

  If ((Get-WmiObject Win32_OperatingSystem | select BuildNumber).BuildNumber -ge 6000) {
    $CommandLine = $MyInvocation.Line.Replace($MyInvocation.InvocationName, $MyInvocation.MyCommand.Definition)
    Write-Verbose "  $CommandLine"
 
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "$CommandLine"

  } else {
    Write-Verbose "System does not support UAC"
    Write-Warning "This script requires administrative privileges. Please re-run with administrative account."
  }
  Break
}

Set-ExecutionPolicy -Scope Process Undefined -Force

if ($(Get-ExecutionPolicy) -eq "Restricted")
{
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
}

Write-Verbose "Starting Chocolatey installation.."
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Azure PowerShell
Write-Verbose "Starting Azure Web Platform Installer..."
cinst webpicmd -y
webpicmd /Install /Products:"Microsoft Azure Powershell with Microsoft Azure Sdk" /AcceptEula

#login to azure
add-azureaccount
$azuresubscriptionname = Get-azuresubscription | select SubscriptionName

#Create Storage Account
Write-Verbose "Creating Storage Account..."
New-AzureStorageAccount -StorageAccountName $tfsstorage -Location $tfslocation
Set-AzureSubscription -SubscriptionName $azuresubscriptionname.SubscriptionName -CurrentStorageAccount $tfsstorage

#Create Cloud Service
Write-Verbose "Creating Cloud Service..."
new-azureservice -ServiceName $tfsservice -Location $tfslocation

#Create Vnet


#Create VM
Write-Verbose "Creating VM..."
#Get image list you want
#$imgs = Get-AzureVMImage
#$imgs | where {$_.Label -like 'sql server*'} | select Label, RecommendedVMSize, PublishedDate | Format-Table -AutoSize
#get image name
$imgnm = Get-AzureVMImage | where {$_.Label -eq 'SQL Server 2014 RTM Standard on Windows Server 2012 R2' -and $_.PublishedDate -eq '2015/4/15 15:00:00'} | select ImageName
New-AzureVMConfig -Name $tfsvm -InstanceSize Basic_A2 -ImageName $imgnm.ImageName ` | Add-AzureProvisioningConfig -Windows -AdminUsername $tfsadmin -Password $tfsadminpwd ` | New-AzureVM -ServiceName $tfsservice -WaitForBoot

Write-Verbose 'Script Done£¡'
Write-Verbose 'Please have your RDP in C:\TFS.RDP'
Get-AzureRemoteDesktopFile -ServiceName $tfsservice -Name $tfsvm -LocalPath 'C:\TFS.RDP'