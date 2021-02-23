$XmlFolder = 'E:\SQLSatData\'

foreach ($XmlFile in Get-ChildItem "$XmlFolder\*.xml") {
    $EventNumber = $XmlFile.Name -replace 'SQLSat', ''
    $EventNumber = $EventNumber -replace '.xml', '' | % PadLeft 4 '0'
    $NewFile = "SQLSat" + $EventNumber + ".xml"
    write-host("$($XmlFile.FullName)  to $NewFile")
    Rename-Item -Path $XmlFile.FullName -NewName $NewFile
}