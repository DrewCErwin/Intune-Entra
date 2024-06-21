<#
Version: 1.0
Author: Drew Erwin
Script: BitlockerBackupGroups
Description: Checks Azure AD for bitlocker keys backed up. Compares that to Intune encrypted devices. 
    Adds all devices that are encrypted with no backup key to BitlockerKeyMissing Azure AD Group.
#>

#Start-Transcript -Path ".\BitlockerKeyBackup.log"

#Tenant ID Needs to be filled in
$TenantID = ""

#Group to set policy on for Key Backup. Devices found will be added to this group
$GroupID = ""

$Modules = @(
"Microsoft.Graph.Intune",
"Microsoft.Graph.Groups",
"Microsoft.Graph.Authentication",
"Microsoft.Graph.DeviceManagement",
"Microsoft.Graph.Identity.DirectoryManagement",
"Microsoft.Graph.Identity.SignIns"
)

foreach ($Module in $Modules)
{
    if (Get-Module -ListAvailable -Name $Module)
    {
        Import-Module $Module
    }
    else
    {
        Install-Module $Module -Force
        Import-Module $Module
    }
}

#Connection String for Graph Powershell
Connect-MgGraph -Scopes 'BitLockerKey.Read.All, DeviceManagementManagedDevices.Read.All, GroupMember.ReadWrite.All, Device.ReadWrite.All, Group.ReadWrite.All, RoleManagement.ReadWrite.Directory, Directory.AccessAsUser.All' -TenantId $TenantID -NoWelcome

#Grab all Bitlocker Keys
$BitLockerKeys = Get-MgInformationProtectionBitlockerRecoveryKey -All

#Create list to hold all Device IDs from current Bitlocker keys
$KeyComputerIDs = @()
foreach ($Key in $BitLockerKeys)
{
    $KeyComputerIDs += $Key.DeviceId
}

#Grab list of all Intune Windows devices
$IntuneDevices = Get-MgDeviceManagementManagedDevice -All -Filter "operatingSystem eq 'Windows'" -Property id,deviceName,userID,isEncrypted,azureADDeviceID | select id,deviceName,userID,isEncrypted,azureADDeviceID

#Create list to hold all devices who do not have their keys backed up
$MissingBitlockerKey = @()

Write-Output "`n`nDevices Missing Bitlocker Keys:"

#Loops through all Intune Devices. Checkes if the device is encrypted. If so checks if it is in the list of Bitlocker keys that are backed up. If not adds to a list
foreach ($Device in $IntuneDevices)
{
    if ($Device.IsEncrypted -eq $true)
    {
        if ($Device.azureADDeviceID -notin $KeyComputerIDs)
        {
            Write-Output "$($Device.deviceName)"
            $MissingBitlockerKey += $Device.azureADDeviceID
        }
    }
}

Write-Output "`n`nDevices No Longer in Azure AD:"

#List for all devices with object ID
$MissingBitlockerKeyObjectID = @()

#Loops through devices missing bitlocker key. Verifies if in Azure AD still. If so passes to group
foreach ($DeviceID in $MissingBitlockerKey)
{
    $temp = Get-MgDevice -Filter "DeviceID eq '$DeviceID'"
    if ($temp -eq $null)
    {
        Write-Output "Device with Azure AD Device ID of $DeviceID is no longer in Azure AD. Needs to be deleted from Intune"
    }
    $MissingBitlockerKeyObjectID += Get-MgDevice -Filter "DeviceID eq '$DeviceID'"
}

#Determine which users need to be removed
$ToBeRemoved = @()
$AlreadyinGroup = @()
$DevicesInGroup = @()

#Get all current members of group BitlockerKeyMissing
$CurrentGroupMembers = Get-MgGroupMember -all -GroupId $GroupID

#Adds all IDs to list for current group members
foreach ($Member in $CurrentGroupMembers)
{
    $DevicesInGroup += Get-MgDevice -DeviceId $Member.ID
}

Write-Output "`n`nCurrent Group Status:"

#Goes through current list of BitlockerKeyMissing. If it no longer needs to be there it gets removed. If it is already in there marks as already in there to not be added again.
foreach ($Device in $DevicesInGroup)
{
    if ($Device.DeviceId -notin $MissingBitlockerKey)
    {
        Write-Output "$($Device.DeviceId) has a key backed up or the device is no longer in Intune"
        #$ToBeRemoved += $Device.DeviceId
        $ToBeRemoved += $Device.Id
    }
    else
    {
        Write-Output "$($Device.DeviceId) is already in the group to backup bitlocker keys"
        $AlreadyinGroup += $Device.Id
    }
}

Write-Output "`n`nDevices to be removed:"

#Remove members that are not needed
foreach ($deviceID in $ToBeRemoved)
{
    Remove-MgGroupMemberDirectoryObjectByRef -GroupId $GroupID -DirectoryObjectId $deviceID
    Write-Output "$DeviceID"
}

Write-Output "`n`nAdding Devices:"

#Add any members who are not added to missing bitlocker key list
foreach ($MissingKey in $MissingBitlockerKeyObjectID)
{
    if ($MissingKey.Id -notin $AlreadyinGroup)
    {
        New-MgGroupMember -GroupId $GroupID -DirectoryObjectId $MissingKey.Id
        Write-Output "Adding device with DeviceID $($MissingKey.Id)"
    }
}

Disconnect-MgGraph

#Stop-Transcript