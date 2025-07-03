Clear-Host

$logdate = Get-Date -Format "yyyyMMdd"
$pingsrc = "10.10.100.20"
$logpath = "$env:userprofile\Desktop\$pingsrc-ping-log-$logdate.txt"

# Log the initial ping source to the screen and append to the text file
Write-Host $pingsrc
Add-Content -Path $logpath -Value $pingsrc

while (1 -eq 1) {
    $vardate = Get-Date # must be in the query to get a fresh date/time
    $result = Test-Connection $pingsrc -Count 1
    if ($result.StatusCode -eq 0) {
        $output = "Connection successful - $vardate"
    } else {
        $output = "Connection failed - $vardate"
    }
    Write-Output $output
    Add-Content -Path $logpath -Value $output
    Start-Sleep -Seconds 15  # Adjust the number of seconds as needed
}
