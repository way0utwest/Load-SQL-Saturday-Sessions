#ViewXML_Basic
# View XML file data from a website

$debug = 1;
# counter for events
$i = 1
$baseURL = "http://www.sqlsaturday.com/eventxml.aspx?sat="

$sourceURL = $baseURL + $i

# debug information
if ($debug -eq 2) {
  Write-Host $sourceURL
  }

$doc = New-Object System.Xml.XmlDocument
$doc.Load($sourceURL)

$nodes = $doc.SelectNodes("//[@event]")
foreach ($element in $nodes) {
  Write-Host "Speaker:" + $element.attributes["title"].value
  }

