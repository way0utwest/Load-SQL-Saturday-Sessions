$folderpath = "H:\SQLSatData\"
$SQLUser = "SQLSatRobot"
$SQLPwd = "AB@dIdea!4Sure"
$servername = "JollyGreenGiant\SQL2012"
$db = "SQLSatAnalysis"
$strConnection = "Server=$servername;Database=$db;Trusted_Connection=False;User ID=$SQLUser;password=$SQLPwd"

function Get-XMLFile{
  param([Parameter(Mandatory=$true)][string]$thefile
        )
  [xml]$eventxml = Get-Content $thefile
  
  return $eventxml
}


function Write-EventToDB {
 param( [string]$title
       ,[string]$start
       ,[string]$city
       ,[string]$state
      )

   $connection = new-object System.Data.SqlClient.SqlConnection $strConnection

   $connection.Open() | Out-Null

   $Command = new-Object System.Data.SqlClient.SqlCommand("Events_Add", $connection) | Out-Null

   $Command.CommandType = [System.Data.CommandType]'StoredProcedure'

   $Command.Parameters.Add("@EventTitle", $eventname)
   $Command.Parameters.Add("@City",  $eventcity)
   $Command.Parameters.Add("@EventDate", $eventstart)
   $Command.Parameters.Add("@EventState", $eventstate)

   $Command.ExecuteNonQuery() | Out-Null

   $connection.Close() | Out-Null
 
   $Command.Dispose() | Out-Null

   $connection.Dispose() | Out-Null
}

$x = 1

Get-ChildItem $folderpath -Filter *.xml |
ForEach-Object {

   $filepath = Get-Content $_.FullName

   #write-host $filepath

   #$doc = Get-XMLFile $filepath
   $doc = $filepath

   $eventname = $doc.GuidebookXML.Guide.name
   $eventstart = $doc.GuidebookXML.Guide.startDate
   $eventcity = $doc.GuidebookXML.Guide.venue.city
   $eventstate = $doc.GuidebookXML.Guide.venue.state

   write-host $eventname

   $connection = new-object System.Data.SqlClient.SqlConnection $strConnection

   $connection.Open() | Out-Null

   $Command = new-Object System.Data.SqlClient.SqlCommand("Events_Add", $connection) 

   $Command.CommandType = [System.Data.CommandType]'StoredProcedure'

   $Command.Parameters.Add("@EventTitle", $eventname)
   $Command.Parameters.Add("@City",  $eventcity)
   $Command.Parameters.Add("@EventDate", $eventstart)
   $Command.Parameters.Add("@EventState", $eventstate)

   $Command.ExecuteNonQuery() | Out-Null

   $connection.Close() | Out-Null
 
   $Command.Dispose() | Out-Null

   $connection.Dispose() | Out-Null
 }
