<#
Version: 1.0
Author: Drew Erwin - Modified from https://github.com/SkipToTheEndpoint/toolsandscripts/blob/main/Remediations/FixWURegKeys/Detection-WURegKeys.ps1
Script: Detectection-WURegKeys
Description: Detection script to check for WUfB service breaking or service affecting registry keys.
#> 

$KeyExists = 0

$KeysToCheck = @(
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

ForEach ($Key in $KeysToCheck) {
    If (((Get-Item 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate').property -contains $key) -or ((Get-Item 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU').property -contains $key)) {
        $KeyExists = $KeyExists + 1
    } 
}

If ($KeyExists -eq 0) {
    Write-Output "No Service Breaking Keys Exist."
    Exit 0
}
else {
    Write-Output "Service Breaking Keys Exist. Remediating."
    Exit 1
}