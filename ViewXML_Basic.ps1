
#ViewXML_Basic
# View XML file data from a website

$debug = 1;
# counter for events
$i = 1
$baseURL = "E:\SQLSatData\SQLSat"

$sourceURL = $baseURL + $i + ".xml"

# debug information
if ($debug -eq 2) {
  Write-Host $sourceURL
  }

$doc = New-Object System.Xml.XmlDocument
$doc.Load($sourceURL)

#$StringWriter = New-Object System.IO.StringWriter 
#$XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter 
#$xmlWriter.Formatting = "indented" 
#$doc.WriteTo($XmlWriter) 
#$XmlWriter.Flush() 
#$StringWriter.Flush() 
#Write-Output $StringWriter.ToString() 

#$doc.SelectNodes("//guide/name") 

$sessions = $doc.SelectNodes("//event") 

foreach ($session in $sessions.ChildNodes) {
  if ($session.Name -eq "title") {
   Write-Host "Title:   "  $session.'#text'
   write-host " "
   
   }
  if ($session.Name -eq "speakers") {
   write-host "Speakers"
   write-host "--------"
   $session.ChildNodes.name 
   }

}