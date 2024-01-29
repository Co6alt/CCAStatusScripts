
#Run this script to set up the Task Scheduler task that calls the powershell script on an Event Viewer trigger

$class = cimclass MSFT_TaskEventTrigger root/Microsoft/Windows/TaskScheduler
$trigger = $class | New-CimInstance -ClientOnly
$trigger.Enabled = $true
$trigger.Subscription = '<QueryList><Query Id="0" Path="CCA"><Select Path="CCA">*[System[Provider[@Name="CCA"] and EventID=0]]</Select></Query></QueryList>'

$ActionParameters = @{
    Execute  = 'powershell.exe'
    Argument = '-WindowStyle Hidden -ExecutionPolicy Bypass -File "%appdata%\CCAStatus\CCA_CurrentStatusV2.ps1"'
}

$Action = New-ScheduledTaskAction @ActionParameters
$Settings = New-ScheduledTaskSettingsSet

$RegSchTaskParameters = @{
    TaskName    = 'CCAStatusMonitor'
    Description = 'Checks on the your CCA Status'
    TaskPath    = '\Event Viewer Tasks\'
    Action      = $Action
    Settings    = $Settings
    Trigger     = $Trigger
}

Register-ScheduledTask @RegSchTaskParameters
