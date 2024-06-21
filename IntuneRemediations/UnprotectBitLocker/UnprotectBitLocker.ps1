<#
Version: 1.0
Author: Drew Erwin
Script: UnprotectBitLocker
Description: Turns off protection for BitLocker
#> 

$BitlockerDrives = Get-BitLockerVolume

foreach ($Drive in $BitlockerDrives)
{
    if($Drive.ProtectionStatus -eq "On")
    {
        Write-Output "Turning off BitLocker Encryption for drive $($Drive.MountPoint)"
        $Drive | Suspend-BitLocker -RebootCount 0
    }
    else
    {
        Write-Output "Drive is already unprotected for drive $($Drive.MountPoint)"
    }
}