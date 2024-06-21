Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\UptimeCheckNotification.log"

function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]
        $ToastTitle,
        [string]
        #[parameter(ValueFromPipeline)]
        $ToastText
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)

    $RawXml = [xml] $Template.GetXml()
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "1"}).AppendChild($RawXml.CreateTextNode($ToastTitle)) > $null
    ($RawXml.toast.visual.binding.text|where {$_.id -eq "2"}).AppendChild($RawXml.CreateTextNode($ToastText)) > $null

    $SerializedXml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $SerializedXml.LoadXml($RawXml.OuterXml)

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($SerializedXml)
    $Toast.Tag = "PowerShell"
    $Toast.Group = "PowerShell"
    $Toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Sonrava Notifications")
    $Notifier.Show($Toast);
}
$Uptime= get-computerinfo | Select-Object OSUptime 
$UptimeDays = $Uptime.OsUptime.Days
$RestartTitle = "Your Computer Needs to Restart Today!"
$RestartMessage = "Your device has been online without a restart for $UptimeDays days. Please restart your computer today. If this computer has not been restarted by the end of the week, an automatic restart will be applied."
Show-Notification -ToastTitle $RestartTitle -ToastText $RestartMessage

Stop-Transcript