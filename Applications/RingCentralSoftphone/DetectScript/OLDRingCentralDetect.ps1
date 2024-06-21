<#
Version: 1.0
Author: Drew Erwin
Script: RingCentralDetect
Description: Detects if RingCentral is Installed
#> 

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\RingCentralDetect.log"

$DesiredVersion = "24.1.3"
$AppDisplayName = "RingCentral Phone"

$RegLocations = @(
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
"HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
"HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
)

$DesiredVersionEdit = [Version]$DesiredVersion
$AppName = "$AppDisplayName*"

Write-Output "Looking for version $DesiredVersion of $AppDisplayName"

$Installed = $false
$InstalledVersion = 0

foreach ($Path in $RegLocations)
{
    if (Test-Path -Path $Path)
    {
        $FoundMSI = $null
        $FoundMSI = Get-ChildItem -Path $Path | Get-ItemProperty | Where-Object {$_.DisplayName -like $AppName} | Select-Object -Property DisplayName, DisplayVersion, UninstallString
        if ($FoundMSI -ne $null)
        {
            foreach ($MSI in $FoundMSI)
            {
                if ([Version]$($MSI.DisplayVersion) -ge $DesiredVersionEdit)
                {
                    $FoundVersion = [Version]$($MSI.DisplayVersion)
                    Write-Output "Found $AppDisplayName with version $($MSI.DisplayVersion) at $Path"
                    $Installed = $true
                }
            }
        }
    }
    else
    {
        Write-Output "$Path does not exist"
    }
}

if (($Installed -eq $true) -and ($FoundVersion -ge $DesiredVersionEdit))
{
    Write-Output "Found Application and Installed to correct version"
    exit 0
}
elseif (($Installed -eq $true) -and ($FoundVersion -lt $DesiredVersionEdit))
{
    Write-Output "Found Application but not installed to correct version"
    exit 1
}
else
{
    Write-Output "Could not find appliction"
    exit 1
}

Stop-Transcript