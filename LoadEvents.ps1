$folderpath = "H:\SQLSatData\"
$SQLUser = "SQLSatRobot"
$SQLPwd = "AB@dIdea!4Sure"
$servername = "JollyGreenGiant\SQL2012"
$db = "SQLSatAnalysis"
$strConnection = "Server=$servername;Database=$db;Trusted_Connection=False;User ID=$SQLUser;password=$SQLPwd"

$connection = new-object System.Data.SqlClient.SqlConnection $strConnection
$connection.Open() | Out-Null

function Get-XMLFile{
  param([Parameter(Mandatory=$true)][string]$thefile
        )
  [xml]$eventxml = Get-Content $thefile
  
  return $eventxml
}

#clear staging tables
$Command = new-Object System.Data.SqlClient.SqlCommand("Events_Staging_Clear", $connection) 
$Command.CommandType = [System.Data.CommandType]'StoredProcedure'
$Command.ExecuteNonQuery() | Out-Null
$Command.Dispose()


Get-ChildItem $folderpath -Filter *.xml |
ForEach-Object {

    #write-host $_.Name

   [xml]$doc = Get-Content -Path $_.FullName


   #write-host $filepath

   #$doc = Get-XMLFile $filepath

   $eventname = $doc.GuidebookXML.guide.name
   $eventstart = $doc.GuidebookXML.guide.startDate
   $eventcity = $doc.GuidebookXML.guide.venue.city
   $eventstate = $doc.GuidebookXML.guide.venue.state
   $twitter = $doc.GuidebookXML.guide.twitterHashtag

   $eventnumber = $eventname.split(" ")[1].substring(1) -as [int]

   if ($eventnumber -ne $null) {

   write-host "[" $eventnumber "]" $eventname "-" $eventcity

   $Command = new-Object System.Data.SqlClient.SqlCommand("Events_CheckNumber", $connection) 

   $Command.CommandType = [System.Data.CommandType]'StoredProcedure'

   $Command.Parameters.Add("@EventID", $eventnumber) | Out-Null
   $Command.Parameters.Add("@ReturnValue", [System.Data.SqlDbType]"Int") | Out-Null
   $Command.Parameters["@ReturnValue"].Direction = [System.Data.ParameterDirection]"ReturnValue"
   
   $Command.ExecuteNonQuery() | Out-Null

   $checkevent = [int]$Command.Parameters["@ReturnValue"].Value

   if ($checkevent -eq 0) {

     $sqlCommand = new-Object System.Data.SqlClient.SqlCommand("Events_Load", $connection) 
     $sqlCommand.CommandType = [System.Data.CommandType]::StoredProcedure
     $sqlCommand.Parameters.Add("@EventNumber", [int]$eventnumber) | Out-Null
     $sqlCommand.Parameters.Add("@EventName", $eventname) | Out-Null
     $sqlCommand.Parameters.Add("@EventDate", $eventstart) | Out-Null
     $sqlCommand.Parameters.Add("@EventCity",  $eventcity) | Out-Null
     $sqlCommand.Parameters.Add("@EventState", $eventstate) | Out-Null
     $sqlCommand.Parameters.Add("@TwitterHashtag", $twitter) | Out-Null

     $sqlCommand.ExecuteNonQuery() | Out-Null
     $sqlCommand.Dispose()
   }

   $Command.Dispose() | Out-Null
   }
 }

 # call the move procedure
 $Command = new-Object System.Data.SqlClient.SqlCommand("EventsLoadFromStaging", $connection) 
 $Command.CommandType = [System.Data.CommandType]'StoredProcedure'
 $Command.ExecuteNonQuery() | Out-Null
 $Command.Dispose() | Out-Null


 # close the connection
 $connection.Close() | Out-Null
 $connection.Dispose() | Out-Null
