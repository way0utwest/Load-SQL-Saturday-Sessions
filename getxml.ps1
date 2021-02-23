# get SQL Saturday data from the site
param($drive="e")

$debug = 1;
# counter for events
$i = 1
$baseURL = "http://www.sqlsaturday.com/eventxml.aspx?sat="




# begin looping
# loop until we find that no files exists or we get to 9999.
# Use 9999 as a terminator
$missedXML = 0

While ($i -lt 9999) {
# begin loop

$DestinationFile = $drive + ":\SQLSatData\SQLSat" + $i + ".xml"
$sourceURL = $baseURL + $i

# debug information
if ($debug -eq 1) {
  write-host "Processing " $DestinationFile
  }

if ($debug -eq 2) {
  Write-Host $sourceURL
  }


# Get file from web server
#Invoke-WebRequest $sourceURL -OutFile $DestinationFile
$doc = New-Object System.Xml.XmlDocument

if (-Not (Test-Path $DestinationFile)) {

  # use try catch here for error handling
  try {
  
    $doc.Load($sourceURL)

    # save file
    if ($debug -eq 1) {
      Write-Host "Saving " $DestinationFile
    }
    $doc.Save($DestinationFile)
  }
  Catch
  {
    # if we can't load the file, assume we're done for now.
    $missedXML++
    Write-Host "error with  #" $i
  }
}
Write-Host "missed files: " $missedXML

$i = $i + 1

if ($missedXML -ge 12) {
 $i = 9999
}
# end loop
}
