<#
Version: 1.0
Author: 
Script: Multi-Registry Key Template
Description: Sets Multiple registry Keys
Run as: System
Context: 64 Bit
#> 

#Replace ending with script name
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\SCRIPTNAME.log"

#Sets variable to check at end for exits
$WrongKey = $false

#Change to number of keys and what needs to be added. First is left as an example
$keys = @(
    @{KeyPath="HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate";KeyName="ActiveHoursEnd";DesiredValue="19"}
    @{KeyPath="HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate";KeyName="ActiveHoursStart";DesiredValue="6"}
    @{KeyPath="HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU";KeyName="NoAutoRebootWithLoggedOnUsers";DesiredValue="1"}
    @{KeyPath="HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate";KeyName="SetActiveHours";DesiredValue="1"}
    @{KeyPath="HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU";KeyName="AUOptions";DesiredValue="4"}
)
<#
Loops through each key and takes the needed effect
    If there is a key and the value does not match it edits the variable to check for exits to 1
    If there is a path but no key it edits the variable to check for exits to 1
    If there is no path it edits the variable to check for exits to 1
#> 
foreach ($key in $keys)
{
    $TestPath = Test-Path $key.KeyPath
    if  ($TestPath -eq $true)
    {
        Write-Output "Path $($key.KeyPath) exists"
        $KeyCheck = Get-Item -LiteralPath $key.KeyPath
        if ($KeyCheck.GetValue($key.KeyName, $null) -ne $null)
        {
            $KeyData = Get-ItemProperty -Path $key.KeyPath -Name $key.KeyName
            $KeyValue = $KeyData.$($key.KeyName)
            if ($KeyValue -eq $key.DesiredValue)
            {
                Write-Output "$($key.KeyName) is showing the correct value of $($key.KeyValue)"
            }
            else
            {
                Write-Output "$($key.KeyName) is showing the value of $($key.KeyValue) instead of $($key.DesiredValue)"
                $WrongKey = $true
            }
        }
        else
        {
            Write-Output "The key $($key.KeyName) does not exist"
            $WrongKey = $true
        }
    }
    else
    {
        Write-Output "$KeyPath does not exist"
        $WrongKey = $true
    }
}

if ($WrongKey -eq $true)
{
    Write-Output "Keys are currently incorrect. Passing to remediation."
    exit 1
}
else
{
    Write-Ouput "Keys are correct value"
    exit 0
}

Stop-Transcript