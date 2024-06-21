<#
Version: 1.0
Author: Drew Erwin
Script: EnableTPM-HP600G3DM
Description: Enables TPM for HP ProDesk 600 G3 DM Desktops 
#> 

Import-Module HP.ClientManagement

#Variables that can be changed
#Setting to true will cause the computer not to restart
$Testing = $false

#Time after setting the TPM settings before restart
$WaitTime = 120

function Check-HPCommands {
    param (
        $cmdName
    )

    if (Get-Command $cmdName -errorAction SilentlyContinue)
    {
        Write-Host "$cmdName exists"
        return $true
    }
    else
    {
        Write-Host "Need to install PowerShell library"
        return $false
    }
}

function TPM-Policy {

    $CurrentBehavior = Get-HPBIOSSettingValue -Name 'TPM Activation Policy'

    if (($CurrentBehavior -eq "F1 to Boot") -or ($CurrentBehavior -eq "Allow user to reject"))
    {
        Write-Host "Changing Behavior to no prompts"
        $BehaviorChange = Set-HPBIOSSettingValue -Name 'TPM Activation Policy' -value "No prompts"
    }
    elseif ($CurrentBehavior -eq "No prompts")
    {
        Write-Host "Current behavior is correct"
    }
    else
    {
        Write-Host "TPM Behavior cannot be read"
        Write-Host $CurrentBehavior
        return $false
    }

    Start-Sleep -Seconds 15
    $BehaviorCheck = Get-HPBIOSSettingValue -Name 'TPM Activation Policy'
    if ($BehaviorCheck -eq "No prompts")
    {
        return $true
    }
    else
    {
        return $false
    }
}

function Enable-TPM {

    $CurrentTPM = Get-HPBIOSSettingValue -Name 'TPM State'

    if ($CurrentTPM -eq "Disable")
    {
        Set-HPBIOSSettingValue -Name 'TPM State' -value "Enable"
    }
    elseif ($CurrentTPM -eq "Enable")
    {
        Write-Host "TPM is already set"
    }
    else
    {
        Write-Host "TPM cannot be read"
        Write-Host $CurrentTPM
        return $false
    }

    Start-Sleep -Seconds 15
    $TPMCheck = Get-HPBIOSSettingValue -Name 'TPM State'
    if ($TPMCheck -eq "Enable")
    {
        return $true
    }
    else
    {
        return $false
    }

}

function Wait-Restart {
    param (
        [int]$WaitSec,
        [bool]$TestCase
    )

    Write-Host "Starting Sleep before Restart"
    Start-Sleep -Seconds $WaitSec
    if ($TestCase -eq $false)
    {
        Write-Host "Restarting computer to enable TPM"
        Restart-Computer -Force
    }
}

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\EnableTPM-HP600G3DM.log"

#Checks to ensure that the HP Powershell library is installed
if (Check-HPCommands -cmdName "Get-HPBIOSSettingValue")
{
    #Checks TPM policy, returns true if it is set correctly after changing
    if (TPM-Policy)
    {
        #Checks TPM setting, returns true if it is set correctly after changing
        if (Enable-TPM)
        {
            #Restarts after a set time if everything is set correctly
            Write-Host "Config Completed"
            #Wait-Restart -WaitSec $WaitTime -TestCase $Testing
        }
    }
}

Stop-Transcript