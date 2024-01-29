# Get the most recent event from the specified log and source
$latestEvent = Get-WinEvent -LogName 'CCA' -FilterXPath "*[System[Provider[@Name='CCA']]]" -MaxEvents 1 | Sort-Object TimeCreated -Descending | Select-Object -First 1
$fullStatus = $latestEvent.Message

# Get pre-emptive alert that status will soon change to available (default time 240 seconds)
if ($fullStatus -like "*In-call status changed to wrapup*"){
    
	#play a sound
	$PlayWav=New-Object System.Media.SoundPlayer
    $PlayWav.SoundLocation="$env:APPDATA\CCAstatus\Polite.wav"
    $PlayWav.playsync()
	
	#Create a pop-up and bring CCA to the front
    $shell =New-Object -ComObject WScript.Shell
    $shell.Popup("WARNING: CCA STATUS ABOUT TO BE CHANGED AUTOMATICALLY",60,"CCA Status Warning",0+16)
    $shell.AppActivate("My Contact Center Agent")

}

#Remove the schedule task that called this script
Unregister-ScheduledTask -TaskName "DelayedStatusCheckCCA" -Confirm:$false

exit