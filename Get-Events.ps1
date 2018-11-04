Clear-Host
$DataPath = "C:\Users\alex\Documents\VISUAL STUDIO CODE\DATA"

$LogName      = "System"
$EventId      = 1074
$FilterXPath  = "*[System[EventID=$EventId]]"
$Days         = -100
$Start        = (get-date).adddays($Days)
$Events       = Get-WinEvent  -LogName $LogName -FilterXPath $FilterXPath | Where-Object {($_.timecreated -ge $Start)}

$CSVpath      = "$DataPath\$EventID\"
if (!(test-path -path $CSVpath)) {new-item -path $CSVpath -itemtype directory}

$Events  | Export-Csv -Encoding Unicode -Path "$DataPath\$EventID\$env:COMPUTERNAME-EventID-$EventId.csv" -NoTypeInformation