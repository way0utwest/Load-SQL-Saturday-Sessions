# get SQL Saturday data from the site

$debug = 1;
# counter for events
$i = 1
$baseURL = "http://www.sqlsaturday.com/eventxml.aspx?sat="



# begin looping
# loop until we find that no files exists or we get to 9999.
# Use 9999 as a terminator

While ($i -lt 420) {
# begin loop
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
#Invoke-WebRequest $sourceURL -OutFile $DestinationFile
$doc = New-Object System.Xml.XmlDocument

# use try catch here for error handling
try {

  $doc.Load($sourceURL)

  # save file
  $doc.Save($DestinationFile)
}
Catch
{
  # if we can't load the file, assume we're done for now.
  Write-Host "error with  #" $i
}


$i = $i + 1
# end loop
}
