<#
Version: 1.0
Author: Drew Erwin
Script: ProtectBitLockerDetect
Description: Turns on protection for BitLocker
#> 

$BitlockerDrives = Get-BitLockerVolume

$pass = $false

foreach ($Drive in $BitlockerDrives)
{
    if($Drive.ProtectionStatus -eq "Off")
    {
        Write-Output "Bitlocker needs to be turned on for drive $($Drive.MountPoint)"
        $Pass = $true
    }
    else
    {
        Write-Output "Drive is already protected for drive $($Drive.MountPoint)"
    }
}

if ($pass -eq $true)
{
    Write-Ouput "To Remediation"
    exit 1
}
else
{
    exit 0
}