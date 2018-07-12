$folderpath = "F:\SQLSatData\"
$SQLUser = "SQLSatRobot"
$SQLPwd = "Blu3Corn"
$servername = "Plato\SQL2014"
$db = "SQLSatAnalysis"
$strConnection = "Server=$servername;Database=$db;Trusted_Connection=False;User ID=$SQLUser;password=$SQLPwd"

$connection = new-object System.Data.SqlClient.SqlConnection $strConnection
$connection.Open() | Out-Null


#clear staging tables
$Command = new-Object System.Data.SqlClient.SqlCommand("SessionsStaging_Clear", $connection) 
$Command.CommandType = [System.Data.CommandType]'StoredProcedure'
$Command.ExecuteNonQuery() | Out-Null
$Command.Dispose()

$debug = 1000
$x = 1


Get-ChildItem $folderpath -Filter *.xml |
ForEach-Object {

    #write-host $_.Name

   [xml]$doc = Get-Content -Path $_.FullName

   $eventname = $doc.GuidebookXML.guide.name
   $eventnumber = $eventname.split(" ")[1].substring(1) -as [int]

   #write-host $filepath

   #$doc = Get-XMLFile $filepath

   Foreach($session in $doc.SelectNodes("//GuidebookXML/events/event") ){

   $title = $session.title
   $speaker = $session.speakers.speaker.name
   $track = $session.track
   $spkID = $session.speakers.speaker.id
   if ($speakerID -eq $null) { $speakerID = 0}

   $eventdescription = $session.description
   write-host "[" $eventnumber "]" $title "by" $speaker
   
   $sqlCommand = new-Object System.Data.SqlClient.SqlCommand("SessionsStaging_Load", $connection) 
   $sqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure

   $sqlCommand.Parameters.Add("@EventID", [int]$eventnumber) | Out-Null
   $sqlCommand.Parameters.Add("@Title", $title) | Out-Null
   $sqlCommand.Parameters.Add("@Speaker", $speaker) | Out-Null
   $sqlCommand.Parameters.Add("@speakerID", $spkID) | Out-Null
   $sqlCommand.Parameters.Add("@desc",  $eventdescription) | Out-Null
   $sqlCommand.Parameters.Add("@SessionTrack", $track) | Out-Null
   
   $err = $sqlCommand.ExecuteNonQuery() #| Out-Null
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
