

    #region Config
    $AppName = "New_Teams_Background_Images_Sync"
    $LogPath = "$env:Temp\logs"
    $LogFile = "$LogPath\$appName.log"
    #Below is the new location from where New Teams uploads Images
    $NewTeamsUploadDir = "$env:USERPROFILE\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads"
    #Below could be any location from where you actually copy or upload images
    $ImageSourceDir = "$env:USERPROFILE\Pictures\Teams Backgrounds" 
    
    #endregion
    #region Logging
    if (!(Test-Path -Path $LogPath)) {
        New-Item -Path $LogPath -ItemType Directory -Force | Out-Null
    }


    Start-Transcript -Path $LogFile -Force
    Write-Host "New Teams Background Change syncing...."

# Ensure New Teams Upload directory exists
if (!(Test-Path -Path $NewTeamsUploadDir -PathType Container)) {
    Write-Host "Directory does not exist. Exiting."
    exit 1
}

#Ensure Images directory exists if not then create it
if (!(Test-Path -Path $ImageSourceDir -PathType Container)) {
    New-Item -Path $ImageSourceDir -ItemType Directory -Force | Out-Null
}

# Get file names in $ImageSourceDir and save to $NewTeamsUploadDir as ImagesInfo.txt
$Files = Get-ChildItem -Path $ImageSourceDir -File
$Files | Select-Object -ExpandProperty Name | Out-File -FilePath (Join-Path -Path $NewTeamsUploadDir -ChildPath "ImagesInfoLast.txt")

# Rename .png files with GUID_thumb and copy to $NewTeamsUploadDir as this is the requirement for the images to show up in New Teams
# Get .png files in $SourceDir
$PNGFiles = Get-ChildItem -Path $ImageSourceDir -Filter "*.png" -File
Remove-Item -Path "$NewTeamsUploadDir\*.png" -Force
# Rename .png files with GUID_thumb and copy to $NewTeamsUploadDir
$PNGFiles | ForEach-Object {
    $NewName = [guid]::NewGuid().ToString() + "_thumb.png"
    Copy-Item -Path $_.FullName -Destination (Join-Path -Path $NewTeamsUploadDir -ChildPath $NewName)
}

Write-Host "Done converting file names to GUIDs and then copying to the Uploads folder for New TEAMS"
Stop-transcript
