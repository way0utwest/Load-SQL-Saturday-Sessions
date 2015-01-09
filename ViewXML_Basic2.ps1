
#ViewXML_Basic
# View XML file data from a website

$debug = 0;
# counter for events
$i = 1
$loopend = 40
$baseURL = "E:\SQLSatData\SQLSat"
$loop = 1
$doc = New-Object System.Xml.XmlDocument


do {

#start large loop
$sourceURL = $baseURL + $i + ".xml"

# debug information
if ($debug -eq 2) {
  Write-Host $sourceURL
  }

  #test the path first
  if (Test-Path $sourceURL) {
    $doc.Load($sourceURL)

#$StringWriter = New-Object System.IO.StringWriter 
#$XmlWriter = New-Object System.XMl.XmlTextWriter $StringWriter 
#$xmlWriter.Formatting = "indented" 
#$doc.WriteTo($XmlWriter) 
#$XmlWriter.Flush() 
#$StringWriter.Flush() 
#Write-Output $StringWriter.ToString() 

#$doc.SelectNodes("//guide/name") 



$event = "SQL Saturday #" + $i


$sessions = $doc.SelectNodes("//event") 
$speakers = ""

foreach ($session in $sessions) {
  

 # write-host $foreach.current
#  if ($foreach.current -neq $loop ) {
#     write-host "Title   : " $title
#     write-host "Speakers: " $speakers
#     $loop = $foreach.current
#     $speakers = ""
#     }

  foreach ($detail in $session.ChildNodes) {

     if ($detail.Name -eq "title") {
       $title = $detail.'#text'
      }
     if ($detail.Name -eq "speakers") {
       foreach ($presenter in $detail.ChildNodes) {
            if ($speakers -gt " ") {
              $speakers = $speakers + ", " + $presenter.Name
              }
              else {
              $speakers = $presenter.Name
              }
            }
        }
     

    }
    write-host $event ": " $title " - " $speakers
    $title = ""
    $speakers = ""

    # increment loop
    
}

# end test path
}
$i++

#end outer loop
} while ($i -lt $loopend)

write-host "end"