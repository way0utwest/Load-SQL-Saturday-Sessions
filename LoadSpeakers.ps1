$folderpath = "F:\SQLSatData\"
$SQLUser = "SQLSatRobot"
$SQLPwd = "Blu3Corn"
$servername = "Plato\SQL2014"
$db = "SQLSatAnalysis"
$strConnection = "Server=$servername;Database=$db;Trusted_Connection=False;User ID=$SQLUser;password=$SQLPwd"

$connection = new-object System.Data.SqlClient.SqlConnection $strConnection
$connection.Open() | Out-Null


#clear staging tables
$Command = new-Object System.Data.SqlClient.SqlCommand("SpeakerStaging_Clear", $connection) 
$Command.CommandType = [System.Data.CommandType]'StoredProcedure'
$Command.ExecuteNonQuery() | Out-Null
$Command.Dispose()

$debug = 1000
$x = 1

Get-ChildItem $folderpath -Filter *.xml |
ForEach-Object {

    write-host $_.Name

   [xml]$doc = Get-Content -Path $_.FullName

   $eventname = $doc.GuidebookXML.guide.name
   $eventnumber = $eventname.split(" ")[1].substring(1) -as [int]

   #write-host $filepath

   #$doc = Get-XMLFile $filepath

   Foreach($speaker in $doc.SelectNodes("//GuidebookXML/speakers/speaker") ){

   $speakerid = $speaker.importID
   $speakername = $speaker.name
   $speakerdescription = $speaker.description
   $speakertwitter = $speaker.twitter
   $speakerlinkedin = $speaker.linkedin
   $speakercontact = $speaker.contactURL
   $speakerimage = $speaker.imageURL
   $speakerheight = $speaker.imageHeight
   $speakerwidth = $speaker.imageWidth

   write-host "[" $speakerid "]" $speakertwitter " for " $speakername
   
   $sqlCommand = new-Object System.Data.SqlClient.SqlCommand("LoadSpeakers", $connection) 
   $sqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure

   $sqlCommand.Parameters.Add("@Speakerid", $speakerid) | Out-Null
   $sqlCommand.Parameters.Add("@Speakername", $speakername) | Out-Null
   $sqlCommand.Parameters.Add("@SpeakerBio", $speakerdescription) | Out-Null
   $sqlCommand.Parameters.Add("@SpeakerTwitter",  $speakertwitter) | Out-Null
   $sqlCommand.Parameters.Add("@SpeakerLinkedIn", $speakerlinkedin) | Out-Null
   $sqlCommand.Parameters.Add("@SpeakerContact", $speakercontact) | Out-Null
   $sqlCommand.Parameters.Add("@SpeakerImage", $speakerimage) | Out-Null
   $sqlCommand.Parameters.Add("@SpeakerImageHeight", $speakerheight) | Out-Null
   $sqlCommand.Parameters.Add("@SpeakerImageWidth", $speakerwidth) | Out-Null

   $sqlCommand.ExecuteNonQuery() 
   $sqlCommand.Dispose()
   #for each $session
   }

 
   #}
   $x += 1
   if ($x -gt $debug) {break}
 }

 # call the move procedure
# $Command = new-Object System.Data.SqlClient.SqlCommand("EventsLoadFromStaging", $connection) 
# $Command.CommandType = [System.Data.CommandType]'StoredProcedure'
# $Command.ExecuteNonQuery() | Out-Null
# $Command.Dispose() | Out-Null


 # close the connection
 $connection.Close() | Out-Null
 $connection.Dispose() | Out-Null
