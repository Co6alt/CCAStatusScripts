# CCAStatusScripts
CCAStatusScripts

Purpose:

These scripts creates a reminder to change the call queue status in the application "My Contact Center". At this time, the configured setting for CCA is to put the user back in an "Available" status 240 seconds after ending a call. I've built these scripts because I often don't have the call window at the forefront, and am not prepared the status to automatically change to "Available". 

Setup Instructions:

1. Create the folder %appdata%\CCAStatus\
2. Move these files to that folder
3. Run the script "SetupInitialTask.ps1"

How it works:

This initial script sets up the Task Scheduler task to run the script "CCA_CurrentStatusV2.ps1" when a change in the status of the application My Contact Center Agent is detected via a log being created for the CCA application (logs are created on sign in/ sign out of the application and any time the status changes)

When the log is detected, if the log message indicates the status was changed to the "call ended" status, then a new task is scheduled to run "EndCall_FollowUp.ps1" after a period of 180 seconds

The "EndCall_FollowUp.PS1" script will run, check the status of the latest log to see if the user is still in the "call ended" status, and alert the user if that's the case -- by playing a sound, creating a pop-up notification, and bringing the CCA window to the front. If the status has already been changed to       anything else, no alerts are created. The second scheduled task is then removed.
