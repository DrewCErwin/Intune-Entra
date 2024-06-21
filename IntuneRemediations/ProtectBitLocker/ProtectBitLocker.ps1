<#
Version: 1.0
Author: Drew Erwin
Script: ProtectBitLocker
Description: Turns on protection for BitLocker
#> 

$BitlockerDrives = Get-BitLockerVolume

foreach ($Drive in $BitlockerDrives)
{
    if($Drive.ProtectionStatus -eq "Off")
    {
        Write-Output "Turning on BitLocker Encryption for drive $($Drive.MountPoint)"
        $Drive | Resume-BitLocker
    }
    else
    {
        Write-Output "Drive is already protected for drive $($Drive.MountPoint)"
    }
}