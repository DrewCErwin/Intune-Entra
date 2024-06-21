<#
Version: 1.0
Author: Drew Erwin
Script: Invoke-UserLogout
Description: Script for manually logging a user out
Run as: System
Context: 64 Bit
#> 

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Invoke-UserLogout.log"

$timeout = 60
Add-Type -AssemblyName PresentationCore,PresentationFramework
$msgBody = "You will be logged out in $timeout seconds"
[System.Windows.MessageBox]::Show($msgBody)

Stop-Transcript
shutdown /L /f $timeout