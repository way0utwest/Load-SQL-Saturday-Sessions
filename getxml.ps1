# get SQL Saturday data from the site

$debug = 1;
# counter for events
$i = 1
$baseURL = "http://www.sqlsaturday.com/eventxml.aspx?sat="


$DestinationFile = "E:\SQLSatData\SQLSat" + $i + ".xml"
$sourceURL = $baseURL + $i

# debug information
if ($debug -eq 1) {
  write-host $DestinationFile
  }

if ($debug -eq 2) {
  Write-Host $sourceURL
  }


# Get file from web server
Invoke-WebRequest $sourceURL -OutFile $DestinationFile

