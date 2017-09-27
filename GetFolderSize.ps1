function Get-FolderSize($folder) {
$OneDrives = $folder
Get-ChildItem $OneDrives | ForEach-Object {
   $Files=0
   $Bytes=0
   $OneDrive = $_
   Get-ChildItem $OneDrive -Recurse -File -Force | ForEach-Object {
       $Files++
       $Bytes += $_.Length
   }
   $Folders = (Get-ChildItem $OneDrive -Recurse -Directory -Force).Count
   $GB = [System.Math]::Round($Bytes/1GB,2)
   Write-Host "Folder ‘$OneDrive’ has $Folders folders, $Files files, $Bytes bytes ($GB GB)"
}
}