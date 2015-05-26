
Function insInit
{
  #Write-Verbose "Enable .Net Framework 3.5"
  #dism /online /enable-feature /featurename:NETFX3 /all
  #Write-Verbose "Enable Basic Authentication"
  #dism /online /enable-feature /featurename:IIS-BasicAuthentication /all
  Write-Verbose "Starting Chocolatey installation.."
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

  # Install NodeJS
  Write-Verbose "Starting NodeJS installation..."
  choco install NodeJs -y
  # Install Azure PowerShell
  Write-Verbose "Starting Azure Web Platform Installer..."
  choco install webpicmd -y
  webpicmd /Install /Products:"Microsoft Azure Powershell with Microsoft Azure Sdk" /AcceptEula

  # Install Microsoft Azure Cross Platform Command Line
  #Write-Verbose "Starting Microsoft Azure Cross Platform Command Line installation"
  #npm install azure-cli -g
  #$npmpath = npm config get prefix
  #setx PATH "$env:path;$npmpath" -m
  # Install WAWSDeploy
  #choco install wawsdeploy -y

  # Install 7zip
  Write-Verbose "Starting 7zip installation..."
  choco install 7zip -y
  # Install Git
  Write-Verbose "Starting git installation..."
  choco install git -y
}

Function insBuild
{
  # Install Java Dev Env
  Write-Verbose "Starting Java Env installation..."
  choco install jdk8 -y
  choco install eclipse -y
  # choco install maven -y
  choco install apache.ant -y
  # choco install tomcat -y

  # Install Python Env
  Write-Verbose "Starting Python Env installation..."
  choco install python -y
  # Install Nuget
  Write-Verbose "Starting Nuget installation..."
  choco install nuget.commandline -y
  # Install putty
  Write-Verbose "Starting Putty installation..."
  choco install putty -y
  # Install Visual Studio Code
  Write-Verbose "Starting Visual Studio Code installation..."
  choco install visualstudiocode -y
}

Function insTfs
{
  $tempdir = Test-Path -Path "C:\temp"
  if(!$tempdir)
  {
    mkdir C:\temp
  }

  Write-Verbose "Downloading TFS"
  Invoke-WebRequest "http://download.microsoft.com/download/2/7/B/27B1E73B-8B2D-4EAF-A3D2-1E64290D9141/tfs_server.exe" -OutFile "c:\temp\tfs2015rc.exe"

  #TFS2015RC install
  c:\temp\tfs2015rc.exe /Full /Quiet
  Write-Verbose "Starting TFS Installation"
  Start-Sleep -s 300
  do
  {
    Start-Sleep -s 60
    $tfsInstalled = Test-Path -Path "$env:ProgramFiles\Microsoft Team Foundation Server 14.0\Tools\TfsConfig.exe"
  }
  until($tfsInstalled)
  Write-Verbose "TFS Installation Completed"
}

Function insVs
{
  #VS2015RC install
  Write-Verbose "Starting VS Installation"
  webpicmd /Install /Products:"Visual Studio Community Edition 2015 Release Candidate" /AcceptEula

  #Start-Sleep -s 600
  #do
  #{
  #  Start-Sleep -s 120
  #  $vsInstalled = Test-Path -Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Common7\IDE\devenv.exe"
  #}
  #until($vsInstalled)
  Write-Verbose "VS Installation Completed"
}

###################################################################################################################

#Get Admin rights
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
#No Administrative rights, it will display a popup window asking user for Admin rights

$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments

break
}

Set-ExecutionPolicy -Scope Process Undefined -Force

if ($(Get-ExecutionPolicy) -eq "Restricted")
{
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
}

# The script has been tested on Powershell 3.0
Set-StrictMode -Version 3

# Set the output level to verbose and make the script stop on error
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

Write-Host "---------------------------------------------------------------------------"
Write-Host "|  Team Foundation Server 2015 RC Deployment Script v1.0                  |"
Write-Host "|  Please Ensure You Have Internet Access                                 |"
Write-Host "|  Installtation File around 5GB, time cost depends on the network speed  |"
Write-Host "---------------------------------------------------------------------------"
Write-Host ""
Write-Host ""
Write-Host "***************************************************************************"
Write-Host "* Please choose your installation option:                                 *"
Write-Host "*  Option[1]: TFS Full (TFS, Visual Studio and Build env)                 *" 
Write-Host "*  Option[2]: TFS and Build without VS (TFS and Build env)                *"
Write-Host "*  Option[3]: TFS only (Server only)                                      *"
Write-Host "*  Option[4]: Build Env Only                                              *"
Write-Host "***************************************************************************"
$insmode = Read-Host



# Grant administrative privileges
#If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
#  Write-Verbose "Script is not run with administrative user"
#
#  If ((Get-WmiObject Win32_OperatingSystem | select BuildNumber).BuildNumber -ge 6000) {
#    $CommandLine = $MyInvocation.Line.Replace($MyInvocation.InvocationName, $MyInvocation.MyCommand.Definition)
#    Write-Verbose "  $CommandLine"
# 
#    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "$CommandLine"
#
#  } else {
#    Write-Verbose "System does not support UAC"
#    Write-Warning "This script requires administrative privileges. Please re-run with administrative account."
#  }
#  Break
#}

If( $insmode -eq 1 )
{
  insInit
  insBuild
  insTfs
  insVs
}
elseif( $insmode -eq 2 )
{
  insInit
  insBuild
  insTfs
}
elseif( $insmode -eq 3 )
{
  insInit
  insTfs
}
elseif( $insmode -eq 4 )
{
  insInit
  insBuild
}
Else
{
    "Error Input"
    Exit
}
#Install SQL
#Write-Verbose "Starting SQLServer 2014 express installation..."
#choco install sqlserver2014express  -y
#Install TFS2013
#Write-Verbose "Starting TFS 2013 express installation..."
#choco install visualstudioteamfoundationserverexpress2013 -y
#Install VS2013
#Write-Verbose "Starting VS2013 ultimate express installation..."
#choco install visualstudio2013ultimate -y

#Write-Verbose "Prerequisites script finished."
#Write-Host -NoNewLine 'Press any key to finish...';
#$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Write-Verbose "Prerequisites script finished. "
Read-Host
# SIG # Begin signature block
# MIIFpwYJKoZIhvcNAQcCoIIFmDCCBZQCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUBDkedTlFm6wWA/r+ZsEv9uLc
# Tx+gggM5MIIDNTCCAiGgAwIBAgIQxO17czeG0b5DXKfr+Wf6WTAJBgUrDgMCHQUA
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
# MRYEFE9zZnlNIJ9I1R592Cy/ORAw+b+9MA0GCSqGSIb3DQEBAQUABIIBAEwTQcv2
# 65su0UDbgWGrN8w2vDXBOx+dXR1FM1evwoPNagv9143obxNXcgyKDW02T+bftg28
# jMsatGuyMwVOFRDCvQdynZHg71kVzBI2MVRwOkuniOHyrLa4rr5bYt2Y3MfdrjIV
# QWgCQ0XiX/XeH3MIF90xR/NO3Zjozo7PJzbX8NOGZXjhxKdIbaQGXCWK/zh324yd
# zttNecYqTfjdRpDvsfBevKuKGP4IHNDUvEQjywKijLfMmbLmgRAJ+VnSqsU698f8
# ibp2yuuKmelA6O9579r5mjttTcmpD8jja1xP4FJD5rQ4aBJaD2in8xWSzeSH2ByQ
# QBeExUVwdvlOSHg=
# SIG # End signature block
