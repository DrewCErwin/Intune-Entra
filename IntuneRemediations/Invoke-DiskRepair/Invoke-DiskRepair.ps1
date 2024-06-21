<#
Version: 1.0
Author: Drew Erwin
Script: Invoke-DiskRepair
Description: Script for manually running disk repair
Run as: System
Context: 64 Bit
#> 

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Invoke-DiskRepair.log"

Repair-Volume -DriveLetter C -OfflineScanAndFix

Stop-Transcript