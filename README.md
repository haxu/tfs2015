Team Foundation Server Installation Script.
===================================

1-tfs-azure-env-config.ps1 is for create Azure Basic A2 VM with SQL Server 2014 standard.
2-tfs-server-installation.ps1 is for install and config TFS
3-tfs-ubuntuagent-install.sh is for install build agent

The Scirpt has been tested on Windows 10, Windows Server 2012 R2 VM and Azure Ubuntu 14.04 LTS VM.

Usage:
-------------------------------------------------------------------
###right click and run with powershell
	or run it directly in cmdlet
	.\1-tfs-azure-env-config.ps1
	.\2-tfs-server-installation.ps1

###tfs-linuxagent-install.sh is for linux bash
	run this script with root
	ubuntu e.g.
	sudo .\3-tfs-ubuntuagent-install.sh



Appendix
-------------------------------------------------------------------
###Windows Installation List:
	Team Foundation Server 2015 RC EN
	Visual Studio Community 2015 RC EN
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

###linux Installation List:
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