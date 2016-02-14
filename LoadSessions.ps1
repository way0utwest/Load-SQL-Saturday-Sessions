$folderpath = "H:\SQLSatData\"
$SQLUser = "SQLSatRobot"
$SQLPwd = "AB@dIdea!4Sure"
$servername = "JollyGreenGiant\SQL2012"
$db = "SQLSatAnalysis"
$strConnection = "Server=$servername;Database=$db;Trusted_Connection=False;User ID=$SQLUser;password=$SQLPwd"

$connection = new-object System.Data.SqlClient.SqlConnection $strConnection
$connection.Open() | Out-Null


#clear staging tables
$Command = new-Object System.Data.SqlClient.SqlCommand("SessionsStaging_Clear", $connection) 
$Command.CommandType = [System.Data.CommandType]'StoredProcedure'
$Command.ExecuteNonQuery() | Out-Null
$Command.Dispose()

$debug = 5000
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
   $eventdescription = $session.description
   write-host "[" $eventnumber "]" $title "by" $speaker
   
   $sqlCommand = new-Object System.Data.SqlClient.SqlCommand("SessionsStaging_Load", $connection) 
   $sqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure

   $sqlCommand.Parameters.Add("@EventID", [int]$eventnumber) | Out-Null
   $sqlCommand.Parameters.Add("@Title", $title) | Out-Null
   $sqlCommand.Parameters.Add("@Speaker", $speaker) | Out-Null
   $sqlCommand.Parameters.Add("@desc",  $eventdescription) | Out-Null

   $sqlCommand.ExecuteNonQuery() | Out-Null
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
