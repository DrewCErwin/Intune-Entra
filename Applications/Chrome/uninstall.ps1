<#
Version: 1.0
Author: Drew Erwin
Script: ChromeUninstall
Description: Uninstalls Chrome
#> 

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\ChromeUninstall.log"

$AppName = "*Chrome*"

$RegPath1 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
$RegPath2 = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"

$Uninstaller = Get-ItemProperty $RegPath1 | Select-Object DisplayName, UninstallString | Where-Object {$_.DisplayName -like $AppName}
$Uninstaller += Get-ItemProperty $RegPath2 | Select-Object DisplayName, UninstallString | Where-Object {$_.DisplayName -like $AppName}

if ($Uninstaller.UninstallString -like "msiexec*")
{
    $ARGS=(($Uninstaller.UninstallString -split ' ')[1] -replace '/I','/X ') + ' /q'
    Start-Process msiexec.exe -ArgumentList $ARGS -Wait
}
else
{
    $UninstallCommand=(($Uninstaller.UninstallString -split '\"')[1])
    $ARGS=(($Uninstaller.UninstallString -split '\"')[2]) + ' --force-uninstall'
    Start-Process $UninstallCommand -ArgumentList $ARGS -Wait
}

Start-Sleep -Seconds 30

$ChromeApp = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo
$ChromeAppEXE = $ChromeApp.FileName

$DesiredVersion = [Version]"124.0.0.0"
if (Test-Path -Path $ChromeAppExe -PathType leaf)
{
    Write-Output "App still exists"
}
else
{
    Write-Output "App has been uninstalled"
}

Stop-Transcript