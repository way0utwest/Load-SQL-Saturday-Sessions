# Parse XML

# Declare main vars
$XmlFolder = 'E:\SQLSatData\xml\'
$PostFolder = 'e:\SQLSatData\md'
$encoding  = New-Object System.Text.UTF8Encoding

#$IndexFile = [IO.StreamWriter]::New("$PostFolder\sqlsat.md", $false, $encoding)

# Write the skeleton for the index file
#$IndexFile.WriteLine("# SQL Saturday Index List")
#$IndexFile.WriteLine("This is the list of SQL Saturday events based on the XML files downloaded from the old site.")
#$IndexFile.WriteLine("&nbsp;")


foreach ($XmlFile in Get-ChildItem "$XmlFolder\*.xml") {
    write-host($XmlFile)

    $Xml = [xml](Get-Content $XmlFile -Encoding UTF8)  
    try{
        
        $StartDate = ([datetime]$xml.GuideBookXML.guide.startDate)
    }
    catch {
        $StartDate = "Unknown"
    }
    if ($StartDate -ne "Unknown") {
        # Extract Data
        $EventNumber = $XmlFile.BaseName.Replace("SQLSat", "")
        $EventTitle = $Xml.GuideBookXML.guide.name
        $Venue = $Xml.GuideBookXML.guide.venue.name
        $VenueStreet = $Xml.GuideBookXML.guide.venue.street
        $VenueCity = $Xml.GuideBookXML.guide.venue.city
        $VenueState = $Xml.GuideBookXML.guide.venue.state


        #post metadata
        $EventDay = $StartDate.Day
        $EventMonth = $StartDate.Month
        $EventMonthName = (Get-Culture).DateTimeFormat.GetMonthName($StartDate.Month)
        write-host($EventMonthName)
        $EventYear = $StartDate.Year
        $PostFile = "$EventYear-$EventMonth-$EventDay-SQLSat-$EventNumber.markdown"
        $PostLink = "$EventYear-$EventMonth-$EventDay-SQLSat-$EventNumber.html"
        $PostFilePath = "$PostFolder\Posts\$PostFile" 
        Write-Host($PostFile)

        #Write to the index file
        #$IndexFile.WriteLine("- [$EventTitle](Posts/$PostFile)")

        #Write File out
        $FileToWrite = [IO.StreamWriter]::New($PostFilePath, $false, $encoding)
        $FileToWrite.WriteLine("---")
        $FileToWrite.WriteLine("layout: ""post"" ")
        $FileToWrite.WriteLine("title: ""$($Eventtitle)"" ")
        $FileToWrite.WriteLine("prettydate: ""$($EventDay) $($EventMonthName) $($EventYear)"" ")
        $FileToWrite.WriteLine("---")
        $FileToWrite.WriteLine("# $EventTitle")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("**Event Date**: $StartDate")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("**Event Location**:")
        $FileToWrite.WriteLine("- $Venue")
        $FileToWrite.WriteLine("- $VenueStreet")
        $FileToWrite.WriteLine("- $VenueCity, $VenueState")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("<a href=""/PDF/$($EventNumber).pdf"">PDF of Schedule</a>")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("This event has completed. All data shown below is from the historical XML public data available.")
        $FileToWrite.WriteLine("<ul>")
        $FileToWrite.WriteLine("   <li><a href=""#sessions"">Sessions</a></li>")
        $FileToWrite.WriteLine("   <li><a href=""#speakers"">Speakers</a></li>")
        $FileToWrite.WriteLine("   <li><a href=""#sponsors"">Sponsors</a></li>")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("# <a name=""sessions""></a>Sessions")
        $FileToWrite.WriteLine("This is a list of sessions from the event, based on the schedule in the XML files.")
        $FileToWrite.WriteLine(" ")

        $FileToWrite.WriteLine("----------------------------------------------------------------------------------- ")
        $SessionList = $xml.GuidebookXML.events
        foreach ($Session in $SessionList.event){ 
            $SessionTitle = $Session.title  
            $FileToWrite.WriteLine(" ")
            $FileToWrite.WriteLine("##Title: $SessionTitle##")   
            $FileToWrite.WriteLine(" ")
            $SessionAbstract = $Session.description
            $FileToWrite.WriteLine("**Abstract**:")
            $FileToWrite.WriteLine("$SessionAbstract")
            $FileToWrite.WriteLine(" ")
            $FileToWrite.WriteLine("**Speaker(s):**")
            foreach ($Presenter in $Session.speakers.speaker) {
                $FileToWrite.WriteLine("- $($Presenter.name)")
            }
            $FileToWrite.WriteLine(" ")
            $SessionRoom = "*Track and Room*: $($Session.track) - $($Session.location.name)"
            $FileToWrite.WriteLine("$SessionRoom")
            $FileToWrite.WriteLine(" ")
            $FileToWrite.WriteLine(" ")
            $FileToWrite.WriteLine(" ")
            $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("## <a name=""#speakers""></a>Speakers")
        $FileToWrite.WriteLine("This is a list of speakers from the XML Guidebook records. The details and URLs were valid at the time of the event.")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine(" ")
        $SpeakerList = $xml.GuidebookXML.speakers
        foreach ($Speaker in $SpeakerList.speaker){ 
            $SpeakerName = $Speaker.name  
            $SpeakerTwitter = ""
            if ($Speaker.twitter -ne "") {
            $SpeakerTwitter = " - [$($Speaker.twitter)](https://www.twitter.com/$($Speaker.twitter))"
            }
            $FileToWrite.WriteLine("**$SpeakerName** $SpeakerTwitter")   
            $SpeakerLI = ""
            if ($Speaker.linkedin -ne "") {
                $SpeakerLI = "LinkedIn: [$SpeakerName]($($Speaker.linkedin))"
                $FileToWrite.WriteLine("$SpeakerLI" )
            }
            $SpeakerContact = ""
            if ($Speaker.ContactURL -ne "") {
            $SpeakerContact = "[$($Speaker.ContactURL)]($($Speaker.ContactURL))"
            $FileToWrite.WriteLine("Contact: $SpeakerContact" )
        }
            $SpeakerDescription = $Speaker.description
            $FileToWrite.WriteLine("$SpeakerDescription" )
            $FileToWrite.WriteLine(" ")
        }
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine(" ")
    
        }
        $FileToWrite.WriteLine("## <a name=""sponsors""></a>Sponsors")
        $FileToWrite.WriteLine("The following is a list of sponsors that helped fund the event:")
        $FileToWrite.WriteLine(" ")
        $Sponsors = $xml.GuidebookXML.sponsors
        foreach ($Sponsor in $Sponsors.sponsor){               
            $SponsorUrl = "[$($Sponsor.name)]($($sponsor.url))"
            $ImageUrl = "$($Sponsor.imageURL)"
            $FileToWrite.WriteLine("$SponsorUrl")   
            $FileToWrite.WriteLine("![logo]($ImageURL =150x150)" )
            $FileToWrite.WriteLine(" ")
        }
        $FileToWrite.WriteLine("[Back to the SQL Saturday Event List](/past.html)")
        $FileToWrite.WriteLine("&nbsp;")
        $FileToWrite.WriteLine("[Back to the home page](/index.html)")

        $FileToWrite.Close()

    }


}

#$IndexFile.Close()