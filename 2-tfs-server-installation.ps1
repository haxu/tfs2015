
Function insInit
{
  #Write-Verbose "Enable .Net Framework 3.5"
  #dism /online /enable-feature /featurename:NETFX3 /all
  #Write-Verbose "Enable Basic Authentication"
  #dism /online /enable-feature /featurename:IIS-BasicAuthentication /all
  Write-Verbose "Starting Chocolatey installation.."
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

  # Install Azure PowerShell
  Write-Verbose "Starting Azure Web Platform Installer..."
  choco install webpicmd -y
  webpicmd /Install /Products:"Microsoft Azure Powershell" /AcceptEula

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
}

Function insBuild
{
  # Install NodeJS
  Write-Verbose "Starting NodeJS installation..."
  choco install NodeJs -y
  # Install Git
  Write-Verbose "Starting git installation..."
  choco install git -y
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
  #Write-Verbose "Starting Visual Studio Code installation..."
  #choco install visualstudiocode -y
}

Function insTfs
{
  $tempdir = Test-Path -Path "C:\temp"
  if(!$tempdir)
  {
    mkdir C:\temp
  }

  Write-Verbose "Downloading TFS..."
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

Function confTfs
{
  Start-Sleep -s 120
  cd 'C:\Program Files\Microsoft Team Foundation Server 14.0\Tools'
  .\tfsconfig unattend /configure /type:standard /inputs:UseWss=False UseReporting=False
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

Function insMenu($insmode)
{
    if([String]::IsNullOrEmpty($insmode))  
    {
        Write-Host "---------------------------------------------------------------------------"
        Write-Host "|  Team Foundation Server 2015 RC Deploy Script v1.0                      |"
        Write-Host "|  Please Ensure You Have Internet Access                                 |"
        Write-Host "|  Installtation File around 5GB, time cost depends on the network speed  |"
        Write-Host "---------------------------------------------------------------------------"
        Write-Host ""
        Write-Host ""
        Write-Host "***************************************************************************"
        Write-Host "* Please choose your deploy option:                                       *"
        Write-Host "*  Option[1]: TFS Full (TFS, Visual Studio and Build env)                 *" 
        Write-Host "*  Option[2]: TFS and Build env without VS (TFS and Build env)            *"
        Write-Host "*  Option[3]: TFS only (Server only)                                      *"
        Write-Host "*  Option[4]: Build Env Only                                              *"
        Write-Host "***************************************************************************"
        $insmode = Read-Host
}
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
  confTfs
}
elseif( $insmode -eq 2 )
{
  insInit
  insBuild
  insTfs
  confTfs
}
elseif( $insmode -eq 3 )
{
  insInit
  insTfs
  confTfs
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

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force

#set-executionpolicy Bypass

# The script has been tested on Powershell 3.0
Set-StrictMode -Version 3

# Set the output level to verbose and make the script stop on error
$VerbosePreference = "Continue"
$ErrorActionPreference = "Stop"

$option = $args

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

insMenu($option)

Write-Verbose "Prerequisites script finished. Systeam will reboot "
Read-Host
shutdown -r