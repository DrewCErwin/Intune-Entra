<#
Version: 1.0
Author: Drew Erwin - Modified from https://github.com/SkipToTheEndpoint/toolsandscripts/blob/main/Remediations/FixWURegKeys/Remediation-WURegKeys.ps1
Script: Remediation-WURegKeys
Description:  Remediation script for WUfB service breaking or service affecting registry keys.
#> 

$ErrorActionPreference = 'Stop'

$KeysToRemove = @(
'DisableDualScan'
'DoNotConnectToWindowsUpdateInternetLocations'
'NoAutoUpdate'
'AutoInstallMinorUpdates'
'AutoRestartDeadlinePeriodInDays'
'AutoRestartNotificationSchedule'
'AutoRestartRequiredNotificationDismissal'
'BranchReadinessLevel'
'EnableFeaturedSoftware'
'EngagedRestartDeadline'
'EngagedRestartSnoozeSchedule'
'EngagedRestartTransitionSchedule'
'IncludeRecommendedUpdates'
'NoAUAsDefaultShutdownOption'
'NoAUShutdownOption'
'NoAutoRebootWithLoggedOnUsers'
'PauseFeatureUpdatesStartTime'
'PauseQualityUpdatesStartTime'
'RebootRelaunchTimeout'
'RebootRelaunchTimeoutEnabled'
'RebootWarningTimeout'
'RebootWarningTimeoutEnabled'
'RescheduleWaitTime'
'RescheduleWaitTimeEnabled'
'ScheduleImminentRestartWarning'
'ScheduleRestartWarning'
'SetAutoRestartDeadline'
'SetAutoRestartNotificationConfig'
'SetAutoRestartNotificationDisable'
'SetAutoRestartRequiredNotificationDismissal'
'SetEDURestart'
'SetEngagedRestartTransitionSchedule'
'SetRestartWarningSchd'
'AcceptTrustedPublisherCerts'
'DeferFeatureUpdates'
'DeferFeatureUpdatesPeriodInDays'
'DeferQualityUpdates'
'DeferQualityUpdatesPeriodInDays'
'UseWUServer'
)

Try {
    ForEach ($Key in $KeysToRemove) {
        Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name $key
        Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name $key
        }
    Exit 0
}
Catch {
    Write-Error "$($_.Exception.Message)"
    Exit 1
}