<#
Version: 1.0
Author: Drew Erwin
Script: ChromeDetection
Description: Detects if Chrome is Installed
#> 

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\ChromeDetection.log"

$ChromeApp = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo
$ChromeAppEXE = $ChromeApp.FileName
$ChromeUpdate = [Version]$ChromeApp.ProductVersion
Write-Output $ChromeApp
Write-Output $ChromeUpdate

$DesiredVersion = [Version]"124.0.0.0"
if (Test-Path -Path $ChromeAppExe -PathType leaf)
{
    if ($ChromeUpdate -ge $DesiredVersion)
    {
        Write-Output "App is installed and correct version"
        exit 0
    }
    else
    {
        Write-Output "App is installed, but version is incorrect"
        exit 1
    }
}
else
{
    Write-Output "App is not installed"
    exit 1
}

Stop-Transcript