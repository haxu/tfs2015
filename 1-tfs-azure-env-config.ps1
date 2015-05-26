#Get Admin rights
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
#No Administrative rights, it will display a popup window asking user for Admin rights

$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments

break
}
# The script has been tested on Powershell 3.0
Set-StrictMode -Version 3

# Set the output level to verbose and make the script stop on error
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

Set-ExecutionPolicy -Scope Process Undefined -Force

if ($(Get-ExecutionPolicy) -eq "Restricted")
{
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
}

$timestamp=get-date -UFormat %y%m%d%H%M
$tfsvm="tfs" + $timestamp
$tfsstorage='tfs' + $timestamp
$tfsservice='tfs' + $timestamp
$tfslocation='East Asia'
$tfsadmin='tfsadmin'
$tfsadminpwd='P2ssw0rd'
$imgnm='fb83b3509582419d99629ce476bcb5c8__SQL-Server-2014-RTM-12.0.2048.0-Std-ENU-Win2012R2-cy15su04'
$tfsrdp='C:\'+ $tfsvm + ".rdp"

if (([System.Environment]::OSVersion.Version.Major) -eq 6)
{
  $AdminKey = 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}'
  $UserKey = 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}'
  Set-ItemProperty -Path $AdminKey -Name 'IsInstalled' -Value 0
  Set-ItemProperty -Path $UserKey -Name 'IsInstalled' -Value 0
  #Stop-Process -Name Explorer
  Write-Host 'IE Enhanced Security Configuration (ESC) has been disabled.' -ForegroundColor Green
}

Write-Verbose "Starting Chocolatey installation.."
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Azure PowerShell
Write-Verbose "Starting Azure Web Platform Installer..."
choco install webpicmd -y
webpicmd /Install /Products:"Microsoft Azure Powershell" /AcceptEula

write-host "Systeam already init, reboot for proceed in 5 sec"
Start-stop -s 5
Restart-Computer -Wait

write-host "***** Please input your Subscriber ID in another window !!! *****"
write-host "!!!!! IF Error Occur, Please Reboot and Run This Script Again !!!!!" -BackgroundColor Red

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
#$imgnm = Get-AzureVMImage | where {$_.Label -eq 'SQL Server 2014 RTM Standard on Windows Server 2012 R2' -and $_.PublishedDate -eq '2015/4/15 15:00:00'} | select ImageName
New-AzureVMConfig -Name $tfsvm -InstanceSize Basic_A2 -ImageName $imgnm ` | Add-AzureProvisioningConfig -Windows -AdminUsername $tfsadmin -Password $tfsadminpwd ` | New-AzureVM -ServiceName $tfsservice -WaitForBoot

Get-AzureRemoteDesktopFile -ServiceName $tfsservice -Name $tfsvm -LocalPath $tfsrdp
Write-Verbose 'Script Done£¡'
Write-Verbose 'Please have your RDP in'
Write-Host $tfsrdp
Write-Verbose 'Please input any key to continue...'
Read-Host
# SIG # Begin signature block
# MIIFpwYJKoZIhvcNAQcCoIIFmDCCBZQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUqAHLeymjQiE3lHWKqzvk8HGR
# ktugggM5MIIDNTCCAiGgAwIBAgIQxO17czeG0b5DXKfr+Wf6WTAJBgUrDgMCHQUA
# MCMxITAfBgNVBAMTGE1vc3NlclBvd2VyU2hlbGxUZXN0Q2VydDAeFw0xNTA1MjYw
# NDEwMjhaFw0zOTEyMzEyMzU5NTlaMCMxITAfBgNVBAMTGE1vc3NlclBvd2VyU2hl
# bGxUZXN0Q2VydDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAIhpLO5g
# UEYt8FHedXoXnwc6ZO3HFZ1bVvPV63fsQ4hkSiAu3SYx7N/Sc//ldiBGXqUxX5ro
# FoekdO1fP92HRz6TQAieJNGrBvXXYtvsSftnDNF3GCpZUUJBxAaZhtDrLZMcn8oD
# rfcuwiXigU9Uze2sP+wzNMAPmSvInYsuC/BVecmyc/Ub7/FxMg1grLxoWXYld/dp
# 4XBEINcCpz9gZ7MNxXP8PLX2vuz5kfPGNj+zg7Y2i519Uum6jgrdVVALX86QM2Za
# mZuD+4nxP1sdtZzwnKed6aI/wNi0rIIxXsKR7S/W72sNWWOJAyAuK5EQ/pWRU8/O
# 0QfphpDV/uyEF2sCAwEAAaNtMGswEwYDVR0lBAwwCgYIKwYBBQUHAwMwVAYDVR0B
# BE0wS4AQf5Nb7E7+jmAYuNFuxbZFBaElMCMxITAfBgNVBAMTGE1vc3NlclBvd2Vy
# U2hlbGxUZXN0Q2VydIIQxO17czeG0b5DXKfr+Wf6WTAJBgUrDgMCHQUAA4IBAQAS
# SvZ9IhSWJzW+nsrDA1VX7OeIOsTjx8+8bwsBaqGe43gKUwsZjl2bhLcIPSxBhGSV
# n5zm+uLB5HZlUsXXHljwwEf3JCIjZwSE+omOHLA93+ctKzjg9D9x+yajcv37GjLk
# 8xBW8J2N3//d826GI69eXM/TlZpHNdUseh3kOHOPF96HYBh/ag6PRvKgFKKVSOa7
# ZDcSr5XgFxenmnCz29fFvKBxRfmoIxitwxlwFpZaWaJVeOJ9/79rsPMo7vW3BKsb
# rsLp2iSsKsvjByX60GjuvLxJUyk+1d0AFVfVVhcWEqTnfGJoU0f4Ei28qw2ZxJ0L
# q3OY39ZjgxQiJxBUYyNGMYIB2DCCAdQCAQEwNzAjMSEwHwYDVQQDExhNb3NzZXJQ
# b3dlclNoZWxsVGVzdENlcnQCEMTte3M3htG+Q1yn6/ln+lkwCQYFKw4DAhoFAKB4
# MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQB
# gjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkE
# MRYEFLUVpeNYtNOVkdz9K9j6VZz6v3L9MA0GCSqGSIb3DQEBAQUABIIBAA3l7z1l
# HAjHQ9j+kon+ICKesKS4xjYD9y+jqUyk13vJ9THt3SuDkeiJyArRiyhI9gllOv+t
# 9q5+SNztPeIm7bq+r54oNUeBc3AfqUCu9cH9GB1c/rREQJvi1PTvBapF5/xaiCIN
# b4t9rj3C8eEVvoY4v0OK7RqUG/SGIaYu5+t0Ie0yb4jqzJ+4vKWwUS3DSSdDFHfl
# X4llJygq+9PEbW1OuYst8p7oLyw7XlN+wuS9t4wJkNGXtVLeSpZUIWLzk7m1iCZz
# 4Ap8TXtgNYBiwHBtJjOvvUke//773oMGO3EdqrmJEck4+7s6s4NI4lkpDTSGFxOj
# v38O9O8OEZ0JykU=
# SIG # End signature block
