# Variables
$taskName = "chromeBookmarksOnedrive"
$scriptName = "chromeBookmarksOnedrive.ps1"
$sourceScriptPath = ".\chromBookmarksOnedrive.ps1" # You need to specify the network share path where the script resides

$commonPath = [System.Environment]::GetFolderPath("CommonApplicationData")
$scriptDirectory = Join-Path -Path $commonPath -ChildPath "Scripts"
$targetScriptPath = Join-Path -Path $scriptDirectory -ChildPath $scriptName

# Ensure the script directory exists
if (-not (Test-Path -Path $scriptDirectory)) {
    New-Item -ItemType Directory -Path $scriptDirectory
}

# Copy the script to the target directory
Copy-Item -Path $sourceScriptPath -Destination $targetScriptPath -Force

# Create the scheduled task
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$targetScriptPath`""
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Users" -LogonType Interactive -RunLevel Limited

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Force

Write-Host "Scheduled task $taskName has been created to run the script at user logon."