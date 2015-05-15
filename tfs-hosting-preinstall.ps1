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

Write-Verbose "Enable .Net Framework 3.5"
dism /online /enable-feature /featurename:NETFX3 /all

Write-Verbose "Enable IIS Basic Authentication"
dism /online /enable-feature /featurename:IIS-BasicAuthentication /all

Write-Verbose "Starting Chocolatey installation.."
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Install NodeJS
Write-Verbose "Starting NodeJS installation..."
cinst NodeJs -y

# Install Azure PowerShell
Write-Verbose "Starting Azure Web Platform Installer..."
cinst webpicmd -y
webpicmd /Install /Products:"Microsoft Azure Powershell with Microsoft Azure Sdk" /AcceptEula

# Install Microsoft Azure Cross Platform Command Line
#Write-Verbose "Starting Microsoft Azure Cross Platform Command Line installation"
#npm install azure-cli -g
#$npmpath = npm config get prefix
#setx PATH "$env:path;$npmpath" -m

# Install WAWSDeploy
#cinst wawsdeploy -y

# Install 7zip
Write-Verbose "Starting 7zip installation..."
choco install 7zip -y

# Install Git
Write-Verbose "Starting git installation..."
choco install git -y

# Install Java Dev Env
Write-Verbose "Starting Java Env installation..."
choco install jre8 -y 
choco install jdk8 -y
choco install eclipse -y
choco install maven -y
choco install apache.ant -y
choco install tomcat -y

# Install Python Env
#Write-Verbose "Starting Python Env installation..."
choco install python -y
#choco install python2 -y
#choco install pip -y
#choco install easy.install -y

# Install Nuget
Write-Verbose "Starting Nuget installation..."
choco install nuget.commandline -y

# Install putty
Write-Verbose "Starting Putty installation..."
choco install putty -y

#choco install curl -y
#choco install wget -y

# Install Visual Studio Code
Write-Verbose "Starting Visual Studio Code installation..."
choco install visualstudiocode -y

#Install SQL
Write-Verbose "Starting SQLServer 2014 express installation..."
choco install sqlserver2014express  -y

#Install TFS2013
Write-Verbose "Starting TFS 2013 express installation..."
choco install visualstudioteamfoundationserverexpress2013 -y

#Install VS2013
Write-Verbose "Starting VS2013 ultimate express installation..."
choco install visualstudio2013ultimate

Write-Verbose "Prerequisites script finished."
Write-Host -NoNewLine 'Press any key to finish...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');