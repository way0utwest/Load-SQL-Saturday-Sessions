
#ViewXML_Basic
# View XML file data from a website

$debug = 0;
# counter for events
$i = 1

#when do we stop?
$loopend = 400
$baseURL = "E:\SQLSatData\SQLSat"
$loop = 1
$doc = New-Object System.Xml.XmlDocument


do {
#start large loop

  # get the filename
  $sourceURL = $baseURL + $i + ".xml"

  # debug information
  if ($debug -eq 2) {
    Write-Host $sourceURL
    }

  #test the path first. If it exists, load the XML
  if (Test-Path $sourceURL) {
    $doc.Load($sourceURL)

    #trap the event number. This will be the ID I use in the database table.
    $event = "SQL Saturday #" + $i

    # get the event node
    $sessions = $doc.SelectNodes("//event") 

    # loop through the various //event nodes
    foreach ($session in $sessions) {
  
    # probably a better way, but I wanted to loop through the various elements and only pick out certain ones
    foreach ($detail in $session.ChildNodes) {

      # If we're on the title node, get the value
      if ($detail.Name -eq "title") {
        $title = $detail.'#text'
       }

      if ($detail.Name -eq "speakers") {
        #placeholder
       }
     #end foreach for $detail
     }

    write-host $event ": " $title 
    
    # placeholder - insert into table here. $i, $title

    $title = ""
    $speakers = ""

   #end foreach for $sessions    
   }

   # end test path
   }
  # increment loop
  $i++

#end outer loop
} while ($i -lt $loopend)

write-host "end"