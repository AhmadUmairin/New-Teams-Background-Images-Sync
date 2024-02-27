# Set source and destination directories
$ImageSourceDir = "$env:USERPROFILE\Pictures\Teams Backgrounds"
$NewTeamsUploadDir = "$env:USERPROFILE\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads"

# Create ImagesInfolatest.txt and list names of all .png files in $ImageSourceDir
$PNGFiles = Get-ChildItem -Path $ImageSourceDir -Filter *.png -File | Select-Object -ExpandProperty Name
$PNGFiles | Out-File -FilePath (Join-Path -Path $NewTeamsUploadDir -ChildPath "ImagesInfolatest.txt")

# Check if ImagesInfoLast.txt exists and content is identical to ImagesInfolatest.txt
$ImagesInfoLastPath = Join-Path -Path $NewTeamsUploadDir -ChildPath "ImagesInfoLast.txt"
if (Test-Path -Path $ImagesInfoLastPath) {
    $ImagesInfoLatestContent = Get-Content -Path (Join-Path -Path $NewTeamsUploadDir -ChildPath "ImagesInfolatest.txt")
    $ImagesInfoLastContent = Get-Content -Path $ImagesInfoLastPath
    if (!(Compare-Object -ReferenceObject $ImagesInfoLastContent -DifferenceObject $ImagesInfoLatestContent -SyncWindow 0)) {
        Write-Output "All images are synced"
    } 
    }
