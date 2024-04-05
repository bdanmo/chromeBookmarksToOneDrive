$taskName = "chromeBookmarksOnedrive"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName}

if ($taskExists) {
    Write-Host "Scheduled task $taskName already exists."
    Exit 0
} else {
    Write-Host "Scheduled task $taskName does not exist."
    Exit 1
}