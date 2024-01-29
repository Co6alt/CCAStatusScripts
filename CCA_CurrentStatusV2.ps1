$SaveLocation= "$env:APPDATA\CCAStatus\CurrentStatus.txt"
$errorLocation= "$env:APPDATA\CCAStatus\errors.txt"

# Get the most recent event from the specified log and source
$latestEvent = Get-WinEvent -LogName 'CCA' -FilterXPath "*[System[Provider[@Name='CCA']]]" -MaxEvents 1 | Sort-Object TimeCreated -Descending | Select-Object -First 1
$fullStatus = $latestEvent.Message

# Warning if the most recent status was changed automatically after a time-out
if ($fullStatus -like "*triggered automatically*"){
    
    $shell =New-Object -ComObject WScript.Shell
    $shell.Popup("WARNING: CCA STATUS CHANGED AUTOMATICALLY",60,"CCA Status Warning",0+16)
}

# Schedule a new task to run in 180 seconds
if ($fullStatus -like "*In-call status changed to wrapup*"){

$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-WindowStyle Hidden -ExecutionPolicy Bypass -File "%appdata%\CCAStatus\EndCall_FollowUp.ps1"'
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(180)

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "DelayedStatusCheckCCA" -Force
}

# Use regular expression to extract text within parentheses
$pattern = '\(([^)]+)\)'
$matches = [regex]::Matches($fullStatus, $pattern)

# Output the matched text within parentheses to a file
if ($matches.Count -gt 0) {
    $status = $matches[0].Groups[1].Value
    $status | Out-File -FilePath $SaveLocation
} else {
    #$latestEvent.TimeCreated | Out-File -FilePath $errorLocation -Append
    #$latestEvent.Message | Out-File -FilePath $errorLocation -Append -NoNewline
}
