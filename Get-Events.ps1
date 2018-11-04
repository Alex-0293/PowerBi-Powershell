Clear-Host
$DataPath    = "C:\Users\alex\Documents\VISUAL STUDIO CODE\DATA"
$Description = "LogData"


$OSVer = [environment]::OSVersion.VersionString

# Get events id depends on os version
switch ($OSVer) {
    "Microsoft Windows NT 6.1.7601 Service Pack 1"  # Win7
    {
        $ShutdownId   = 1074
        $UpdatesId    = @(19,20,21,22,23,24)
    }
    "Microsoft Windows NT 10.0.14393.0"             # Win2016
    {
        $ShutdownId   = 1074
        $UpdatesId    = @(19,26,41,25)
    }
    
    Default 
    {}
}

$LogName      = "System"

$Ids          = $UpdatesId + $ShutdownId
$EventIds     = ($Ids  |ForEach-Object{"EventID=$_"}) -join " or "
$FilterXPath  = "*[System[$EventIds]]"
$Days         = -100
$Start        = (get-date).adddays($Days)
$Events       = Get-WinEvent  -LogName $LogName -FilterXPath $FilterXPath | Where-Object {($_.timecreated -ge $Start)}

$CSVpath      = "$DataPath\$Description\"
if (!(test-path -path $CSVpath)) {new-item -path $CSVpath -itemtype directory}

$Events  | Export-Csv -Encoding Unicode -Path "$DataPath\$Description\$env:COMPUTERNAME-$Description.csv" -NoTypeInformation