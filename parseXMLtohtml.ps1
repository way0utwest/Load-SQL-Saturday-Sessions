# Parse XML

# Declare main vars
$XmlFolder = 'E:\SQLSatData\xml\'
$PostFolder = 'E:\Documents\git\SQLSaturday\events'
$PastFolder = 'E:\Documents\git\SQLSaturday'
$encoding  = New-Object System.Text.UTF8Encoding

#$IndexFile = [IO.StreamWriter]::New("$PostFolder\sqlsat.md", $false, $encoding)

# Write the skeleton for the index file
#$IndexFile.WriteLine("# SQL Saturday Index List")
#$IndexFile.WriteLine("This is the list of SQL Saturday events based on the XML files downloaded from the old site.")
#$IndexFile.WriteLine("&nbsp;")

$PastFilePath = "$PastFolder\pastevent.html" 
Write-Host($PastFilePath)
$PastFileToWrite = [IO.StreamWriter]::New($PastFilePath, $false, $encoding)
$PastFileToWrite.WriteLine(" ")

foreach ($XmlFile in Get-ChildItem "$XmlFolder\*.xml") {
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
        $EventYear = $StartDate.Year
        $PostLink = "$EventYear-$EventMonth-$EventDay-SQLSat-$EventNumber.html"
        $PostFilePath = "$PostFolder\$PostLink" 
        Write-Host($PostLink)

        #Write to the index file
        $PastFileToWrite.WriteLine("<tr>")
        $PastFileToWrite.WriteLine("<td><div class=""hero-box mt-3 align-self-center flex-nowrap text-uppercase""><a href=""events/$($PostLink)"">$EventTitle</a></div></td>")
        $PastFileToWrite.Write("<td><div class=""hero-box mt-3 align-self-center flex-nowrap""><div class=""nav-link"">$EventYear-")
        if ($EventMonth -lt 10) {
            $PastFileToWrite.Write("0")
        }
        $PastFileToWrite.Write("$EventMonth-")
        if ($EventDay -lt 10) {
            $PastFileToWrite.Write("0")
        }
        $PastFileToWrite.WriteLine("$EventDay</div></td>")
        $PastFileToWrite.WriteLine("</tr>")

        #Write File out
        $FileToWrite = [IO.StreamWriter]::New($PostFilePath, $false, $encoding)
        $FileToWrite.WriteLine("        <!DOCTYPE html>")
        $FileToWrite.WriteLine("<html lang=""en"">")
        $FileToWrite.WriteLine("    <head>")
        $FileToWrite.WriteLine("        <meta charset=""utf-8"" />")
        $FileToWrite.WriteLine("        <meta name=""viewport"" content=""width=device-width, initial-scale=1, shrink-to-fit=no"" />")
        $FileToWrite.WriteLine("        <meta name=""description"" content=""SQL Saturday $($EventTitle)"" />")
        $FileToWrite.WriteLine("        <meta name=""author"" content="" />")
        $FileToWrite.WriteLine("        <title>SQL Saturdays</title>")
        $FileToWrite.WriteLine("        <link rel=""icon"" type=""image/x-icon"" href=""../assets/img/favicon.ico"" />")
        $FileToWrite.WriteLine("        <!-- Font Awesome icons (free version)-->")
        $FileToWrite.WriteLine("        <script src=""https://use.fontawesome.com/releases/v5.15.1/js/all.js"" crossorigin=""anonymous""></script>")
        $FileToWrite.WriteLine("        <!-- Google fonts-->")
        $FileToWrite.WriteLine("        <link href=""https://fonts.googleapis.com/css?family=Montserrat:400,700"" rel=""stylesheet"" type=""text/css"" />")
        $FileToWrite.WriteLine("        <link href=""https://fonts.googleapis.com/css?family=Droid+Serif:400,700,400italic,700italic"" rel=""stylesheet"" type=""text/css"" />")
        $FileToWrite.WriteLine("        <link href=""https://fonts.googleapis.com/css?family=Roboto+Slab:400,100,300,700"" rel=""stylesheet"" type=""text/css"" />")
        $FileToWrite.WriteLine("        <link href=https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.1/css/bootstrap.css rel=stylesheet>")
        $FileToWrite.WriteLine("        <!-- Core theme CSS (includes Bootstrap)-->")
        $FileToWrite.WriteLine("        <link href=""../css/styles.css"" rel=""stylesheet"" />")
        $FileToWrite.WriteLine("    </head>")
        $FileToWrite.WriteLine("    <body id=""page-top"">")
        $FileToWrite.WriteLine("        <!-- Navigation-->")
        $FileToWrite.WriteLine("        <nav class=""navbar navbar-expand-lg navbar-dark fixed-top"" id=""mainNav"">")
        $FileToWrite.WriteLine("            <div class=""container"">")
        $FileToWrite.WriteLine("                <a class=""navbar-brand js-scroll-trigger"" href=""#page-top"">")
        $FileToWrite.WriteLine("                    $($EventTitle)")
        $FileToWrite.WriteLine("                    <!-- <img src=""assets/img/navbar-logo.svg"" alt=""Navlogo"" /> -->")
        $FileToWrite.WriteLine("                </a>")
        $FileToWrite.WriteLine("                <button class=""navbar-toggler navbar-toggler-right"" type=""button"" data-toggle=""collapse"" data-target=""#navbarResponsive"" aria-controls=""navbarResponsive"" aria-expanded=""false"" aria-label=""Toggle navigation"">")
        $FileToWrite.WriteLine("                    Menu")
        $FileToWrite.WriteLine("                    <i class=""fas fa-bars ml-1""></i>")
        $FileToWrite.WriteLine("                </button>")
        $FileToWrite.WriteLine("                <div class=""collapse navbar-collapse"" id=""navbarResponsive"">")
        $FileToWrite.WriteLine("                    <ul class=""navbar-nav text-uppercase ml-auto"">")
        $FileToWrite.WriteLine("                        <li class=""nav-item""><a class=""nav-link js-scroll-trigger"" href=""../index.html"">SQL Saturday home</a></li> ")
        $FileToWrite.WriteLine("                        <li class=""nav-item""><a class=""nav-link js-scroll-trigger"" href=""../past.html"">Past Events</a></li> ")
        $FileToWrite.WriteLine("                        <li class=""nav-item""><a class=""nav-link js-scroll-trigger"" href=""#schedule"">Schedule</a></li>")
        $FileToWrite.WriteLine("                        <li class=""nav-item""><a class=""nav-link js-scroll-trigger"" href=""#speakers"">Speakers</a></li>")
        $FileToWrite.WriteLine("                        <li class=""nav-item""><a class=""nav-link js-scroll-trigger"" href=""#sponsors"">Sponsors</a></li>")
        $FileToWrite.WriteLine("                    </ul>")
        $FileToWrite.WriteLine("                </div>")
        $FileToWrite.WriteLine("            </div>")
        $FileToWrite.WriteLine("        </nav>")
        $FileToWrite.WriteLine("        <!-- Masthead-->")
        $FileToWrite.WriteLine("        <header class=""masthead"">")
        $FileToWrite.WriteLine("            <div class=""container"">")
        
        $FileToWrite.WriteLine("        <div class=""masthead-heading text-uppercase"">$EventTitle</div>")
        $FileToWrite.WriteLine("        <div class=""masthead-subheading"">This event was held on $EventYear-$EventMonth-$EventDay</div>")
        $FileToWrite.WriteLine("        <p><b>Event Location</b>:</p>")
        #$FileToWrite.WriteLine("        <ul>")
        $FileToWrite.WriteLine("        <p>$Venue</p>")
        $FileToWrite.WriteLine("        <p>$VenueStreet</p>")
        $FileToWrite.WriteLine("        <p>$VenueCity, $VenueState</p>")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("<!-- Schedule-->")
        $FileToWrite.WriteLine("<section class=""page-section"" id=""schedule"">")
        $FileToWrite.WriteLine("    <div class=""container"">")
        $FileToWrite.WriteLine("        <div class=""text-center"">")
        $FileToWrite.WriteLine("            <h2 class=""section-heading text-uppercase"">Schedule</h2>")
        $FileToWrite.WriteLine("            <div class=""alert alert-light"" role=""alert"">")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("<p><a href=""./Assets/PDF/$($EventNumber).pdf"">PDF of Schedule</a></p>")
        $FileToWrite.WriteLine(" ")
        $SessionList = $xml.GuidebookXML.events
        foreach ($Session in $SessionList.event){ 
            $SessionTitle = $Session.title  
            $FileToWrite.WriteLine(" ")
            $FileToWrite.WriteLine("<h3>$SessionTitle</h3>")   
            $FileToWrite.WriteLine(" ")
            $SessionAbstract = $Session.description
            $FileToWrite.WriteLine("<p><b>Abstract</b>:</p>")
            $FileToWrite.WriteLine("<p>$SessionAbstract</p>")
            $FileToWrite.WriteLine("<p>&nbsp;</p> ")
            $FileToWrite.WriteLine("<p><b>Speaker(s):</b> ")
            foreach ($Presenter in $Session.speakers.speaker) {
                $FileToWrite.WriteLine("<b>$($Presenter.name)</b>, ")
            }
            $FileToWrite.WriteLine("</p>")
            $SessionRoom = "<p><b>Track and Room:</b> $($Session.track) - $($Session.location.name) - $SessionRoom</p>"
            $FileToWrite.WriteLine("<hr>")
 
        }


        $FileToWrite.WriteLine("<!-- Speakers-->")
        $FileToWrite.WriteLine("<section class=""page-section"" id=""speakers"">")
        $FileToWrite.WriteLine("    <div class=""container"">")
        $FileToWrite.WriteLine("        <div class=""text-center"">")
        $FileToWrite.WriteLine("            <h2 class=""section-heading text-uppercase"">Speakers</h2>")
        $FileToWrite.WriteLine("            <div class=""alert alert-light"" role=""alert"">")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("<p>This is a list of speakers from the XML Guidebook records. The details and URLs were valid at the time of the event.</p>")
        $SpeakerList = $xml.GuidebookXML.speakers
        foreach ($Speaker in $SpeakerList.speaker){ 
            $SpeakerName = $Speaker.name  
            $SpeakerTwitter = ""
            $FileToWrite.WriteLine("<h3 class=""section-heading"">$SpeakerName")   
            if ($Speaker.twitter -ne "") {
                $SpeakerTwitter = " - <a href=""https://www.twitter.com/$($Speaker.twitter)"">$($Speaker.twitter)</a>"
                }
                $FileToWrite.WriteLine("$SpeakerTwitter")
                $FileToWrite.WriteLine("</h3>")   
            $SpeakerLI = ""
            if ($Speaker.linkedin -ne "") {
                $SpeakerLI = "LinkedIn: <a href=""$($Speaker.linkedin)"">$($Speaker.linkedin)</a>"
                $FileToWrite.WriteLine("<p>$SpeakerLI</p>" )
                $FileToWrite.WriteLine(" ")
            }
            $SpeakerContact = ""
            if ($Speaker.ContactURL -ne "") {
            $SpeakerContact = "<a href=""$($Speaker.ContactURL)"">$($Speaker.ContactURL)</a>"
            $FileToWrite.WriteLine("<p>Contact: $SpeakerContact</p>" )
            $FileToWrite.WriteLine(" ")
        }
            $SpeakerDescription = $Speaker.description
            $FileToWrite.WriteLine("<p>$SpeakerDescription</p>" )
            $FileToWrite.WriteLine(" ")
        }

        $FileToWrite.WriteLine("<!-- Sponsors-->")
        $FileToWrite.WriteLine("<section class=""page-section"" id=""sponsors"">")
        $FileToWrite.WriteLine("    <div class=""container"">")
        $FileToWrite.WriteLine("        <div class=""text-center"">")
        $FileToWrite.WriteLine("            <h2 class=""section-heading text-uppercase"">Sponsors</h2>")
        $FileToWrite.WriteLine("            <div class=""alert alert-light"" role=""alert"">")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("<p>The following is a list of sponsors that helped fund the event.</p>")
        $FileToWrite.WriteLine(" ")
        $Sponsors = $xml.GuidebookXML.sponsors
        foreach ($Sponsor in $Sponsors.sponsor){               
            $SponsorUrl = "<a href=""$($sponsor.url)"">$($Sponsor.name)</a>"
            $ImageUrl = "$($Sponsor.imageURL)"
            $FileToWrite.WriteLine("<p>$SponsorUrl</p>")   
            #$FileToWrite.WriteLine("<p><img src=""$ImageURL"" width=150 height=x150></p>")
            $FileToWrite.WriteLine(" ")
        }
        $FileToWrite.WriteLine("<!-- Footer-->")
        $FileToWrite.WriteLine("<footer class=""footer py-4"">")
        $FileToWrite.WriteLine("    <div class=""container"">")
        $FileToWrite.WriteLine("        <div class=""row align-items-center"">")
        $FileToWrite.WriteLine("            <div class=""col-lg-4 text-lg-left"">Copyright &copy;SQL Saturday 2021</div>")
        $FileToWrite.WriteLine("            <div class=""col-lg-4 my-3 my-lg-0"">")
        $FileToWrite.WriteLine("                <a class=""btn btn-dark btn-social mx-2"" href=""https://twitter.com/sqlsaturday""><i class=""fab fa-twitter""></i></a>")
        #$FileToWrite.WriteLine("                <!-- ")
        $FileToWrite.WriteLine("                <a class=""btn btn-dark btn-social mx-2"" href=""https://www.facebook.com/groups/58052797867""><i class=""fab fa-facebook-f""></i></a>")
        $FileToWrite.WriteLine("                <a class=""btn btn-dark btn-social mx-2"" href=""https://www.linkedin.com/groups/13945573/""><i class=""fab fa-linkedin-in""></i></a>")
        $FileToWrite.WriteLine("                <a class=""btn btn-dark btn-social mx-2"" href=""mailto:support@datasaturdays.com""><i class=""far fa-envelope""></i></a>")
        $FileToWrite.WriteLine("            </div>")
        $FileToWrite.WriteLine("            <div class=""col-lg-4 text-lg-right"">")
        $FileToWrite.WriteLine("                <a class=""mr-3"" href=""../privacy.html"">Privacy Policy</a>")
        $FileToWrite.WriteLine("                <a href=""../terms.html"">Terms of Use</a>")
        $FileToWrite.WriteLine("            </div>")
        $FileToWrite.WriteLine("        </div>")
        $FileToWrite.WriteLine("    </div>")
        $FileToWrite.WriteLine("</footer>")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("<!-- Bootstrap core JS-->")
        $FileToWrite.WriteLine(" ")
        $FileToWrite.WriteLine("<script src=""https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js""></script>")
        $FileToWrite.WriteLine("<script src=""https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js""></script>")
        $FileToWrite.WriteLine("<!-- Third party plugin JS-->")
        $FileToWrite.WriteLine("<script src=""https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.4.1/jquery.easing.min.js""></script>")
        $FileToWrite.WriteLine("<!-- Core theme JS-->")
        $FileToWrite.WriteLine("<script src=""../js/scripts.js""></script>")
        $FileToWrite.WriteLine("    </body>")
        $FileToWrite.WriteLine("</html>")

        $FileToWrite.Close()

    }


}
$PastFileToWrite.Close()
