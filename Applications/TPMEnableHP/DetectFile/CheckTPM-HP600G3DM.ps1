<#
Version: 1.0
Author: Drew Erwin
Script: CheckTPM-HP600G3DM
Description: Enables TPM for HP ProDesk 600 G3 DM Desktops 
#> 

Import-Module HP.ClientManagement

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
        Write-Host "Behavior is set to $CurrentBehavior"
        return $false
    }
    elseif ($CurrentBehavior -eq "No prompts")
    {
        Write-Host "Current behavior is correct"
        return $true
    }
    else
    {
        Write-Host "TPM Behavior cannot be read"
        Write-Host $CurrentBehavior
        return $false
    }
}

function Enable-TPM {

    $CurrentTPM = Get-HPBIOSSettingValue -Name 'TPM State'

    if ($CurrentTPM -eq "Disable")
    {
        Write-Host "TPM is set to disabled"
        return $false
    }
    elseif ($CurrentTPM -eq "Enable")
    {
        Write-Host "TPM is already set"
        return $true
    }
    else
    {
        Write-Host "TPM cannot be read"
        Write-Host $CurrentTPM
        return $false
    }
}

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\CheckTPM-HP600G3DM.log"

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
            exit 0
        }
        else
        {
            Write-Host "TPM is not enabled"
            exit 1
        }
    }
    else
    {
        Write-Host "TPM policy is not set correctly"
        exit 1
    }
}
else
{
    Write-Host "HP Script Library is not installed"
    exit 1
}

Stop-Transcript