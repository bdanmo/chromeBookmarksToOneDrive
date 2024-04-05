# Define the paths
$tempBookmarksPath = [System.IO.Path]::Combine($env:TEMP, "Google", "Chrome", "User Data", "Default", "Bookmarks")
$oneDriveBookmarksPath = [System.IO.Path]::Combine($env:USERPROFILE, "OneDrive - Senneca Holdings", "Bookmarks", "Bookmarks")
 
# Ensure the target directory exists
$oneDriveBookmarksDir = [System.IO.Path]::GetDirectoryName($oneDriveBookmarksPath)
if (-not (Test-Path $oneDriveBookmarksDir)) {
    New-Item -ItemType Directory -Path $oneDriveBookmarksDir | Out-Null
}
 
# Function to copy Bookmarks file if conditions are met
function Copy-BookmarksFile($source, $destination) {
    if (Test-Path $source) {
        $sourceInfo = Get-Item $source
        $destinationExists = Test-Path $destination
        if ($destinationExists) {
            $destinationInfo = Get-Item $destination
            # Only copy if source is newer than destination
            if ($sourceInfo.LastWriteTime -gt $destinationInfo.LastWriteTime) {
                Copy-Item -Path $source -Destination $destination -Force
            }
        } else {
            Copy-Item -Path $source -Destination $destination -Force
        }
    }
}
 
# Copy from %TEMP% to OneDrive if the OneDrive file is older or doesn't exist
Copy-BookmarksFile -source $tempBookmarksPath -destination $oneDriveBookmarksPath
 
# Now the inverse, from OneDrive to %TEMP% if the %TEMP% file is older or doesn't exist
Copy-BookmarksFile -source $oneDriveBookmarksPath -destination $tempBookmarksPath