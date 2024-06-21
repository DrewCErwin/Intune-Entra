<#
Version: 1.0
Author: Drew Erwin
Script: HorizonDetect
Description: Detects Horizon
#> 

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\HorizonDetection.log"

$AppName = "VMware Horizon Client*" # DisplayName of App
$AppVersion = "8.2.0.18176" # DisplayVersion of the App

# Gather all the apps in the Add/Remove Programs Registry Keys
$Apps = (Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\) | Get-ItemProperty | select DisplayName, DisplayVersion
$Apps += (Get-ChildItem HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\) | Get-ItemProperty | select DisplayName
$Apps += (Get-ChildItem HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\) | Get-ItemProperty | select DisplayName, DisplayVersion

$AllApps = $Apps | Where-Object {($_.DisplayName -like $AppName)}
Write-Output $AllApps

# Check is the App DisplayName is found and the version in the registry is greater than or equal to the specified AppVersion
$AppFound = $Apps | Where-Object {($_.DisplayName -like $AppName) -and ([version]$_.DisplayVersion -ge [version]$AppVersion)}

# Exit with correct code
# Comment out exit codes for testing
if ($AppFound)
{
	Write-Output "Installed"
    Stop-Transcript
    exit 0
}
else
{
    Write-Output "Not Installed"
    Stop-Transcript
    exit 1
}