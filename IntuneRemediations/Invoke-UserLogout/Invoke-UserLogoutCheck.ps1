<#
Version: 1.0
Author: Drew Erwin
Script: Invoke-UserLogoutCheck
Description: Script for manually logging a user out
Run as: System
Context: 64 Bit
#> 

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Invoke-UserLogoutCheck.log"

# Always trigger
Write-Host "Script will always be triggered"
exit 1

Stop-Transcript