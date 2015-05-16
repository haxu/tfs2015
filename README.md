TFS2015RC Auto Installation Script.

The script help to install Microsoft Team Foundation Server 2015 RC and build environment with quiet mode.

All the software installation depend on internet connection.

This Scirpt has been tested on Azure Windows Server 2012 R2 VM and Azure Ubuntu 14.04 LTS VM.

Usage:
-------------------------------------------------------------------
tfs-server-install.ps1 is for windows server powershell

run it directly
.\tfs-server-install.ps1

tfs-linuxagent-install.sh is for linux bash

run this script with root

ubuntu e.g.
sudo .\tfs-linuxagent-install.sh
-------------------------------------------------------------------


Appendix
-------------------------------------------------------------------
tfs-server-install.ps1 Installation List:
Team Foundation Server 2015 RC EN
Visual Studio 2015 RC EN
Visual Studio Code
Chocolatey
Azure Web Platform Installer
Node.js
Python
JDK8
Eclipse
Ant
Nuget
Putty
Git
7zip

tfs-linuxagent-install.sh Installation List:
vsoagent
Node.js
GCC
python
JDK
Ant
Maven
Cmake
Gulp
LLVM
Wget
Git