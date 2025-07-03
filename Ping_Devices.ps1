clear-host

# Must supply a list of (just) workstations for this to work
$wks = get-content $env:userprofile\desktop\pinglist.txt

# $LogFiller=@()
# $LogYesPing=@()
# $LogNoPing=@()

$results=@()
$PingStatus


$logFilePath = "$env:userprofile\desktop\results.csv"

if (test-path $logFilePath) {remove-item $logFilePath -force}

# $LogYesPing += "PINGS"
# $LogNoPing += "DOESN'T PING"

$padding=" " * 10	# Adjusted padding length so NoNewLine is clean.

foreach ($wk in $wks) {
    Write-Host "`rEvaluating: $wk$padding" -NoNewline
     $PingStatus = if (Test-Connection -ComputerName $wk -count 1 -Quiet) {
        # $logyesping += $wk
	"PING_YES"
     } else {
        # $lognoping += $wk
	"PING_NO"
     }


    # Get AD computer properties and add custom PingStatus column
    $result = Get-ADComputer -Identity $wk -Properties name, description,canonicalname | Select-Object name, description, @{Name="Site";Expression={
    $canonicalName = $_.CanonicalName
    $startIndex = 27
    $endIndex = $canonicalName.IndexOf("/", $startIndex)
    if ($endIndex -eq -1) {
        $canonicalName.Substring($startIndex)
    } else {
        $canonicalName.Substring($startIndex, $endIndex - $startIndex)
    }
}}, @{Name="PingStatus";Expression={$PingStatus}}
    
    # Log the result to the log file
    # $result | ForEach-Object {
    #    "$($_.name) $($_.description) $PingStatus" | Add-Content -Path $logFilePath
    #}

#$results.Add($result) | out-null
$results += $result
}

$sortedResults = $results | sort-object name -descending

$sortedResults | Export-Csv -Path $logFilePath -NoTypeInformation


<#
# Write all log entries to the log file
$LogYesPing | Add-Content -Path $logFilePath
1..3 | ForEach-Object { $LogFiller +="" | Add-Content -Path $logFilePath }
$LogNoPing | Add-Content -Path $logFilePath
1..5 | ForEach-Object { $LogFiller +="" | Add-Content -Path $logFilePath }
#>

#blank
