$LogDetails = @()
$logInOut = @()

$InstanceID = "4624","4625","4634","4647","4648","4779"

$WinEvent = Get-WinEvent -Path .\WinEvent.evtx | Where-Object {($_.Id -in $InstanceID) -and ($_.TimeCreated -ge $((Get-Date).AddDays(-30)))}

foreach ($e in $WinEvent) {
    # UserId will vary depending on event type:
    if (($e.Id -eq 4624) ) {
        $UserId = $e.properties[5].value
        $LogonID = $e.properties[7].value
    } elseif (($e.Id -eq 4648) -or ($e.Id -eq 4625)) {
        $UserId = $e.properties[5].value
        $LogonID = $null
    } elseif (($e.Id -eq 4634) -or ($e.Id -eq 4647)) {
        $UserId = $e.properties[1].value
        $LogonID = $e.properties[3].value
    } elseif ($e.Id -eq 4779) {
        $UserId = $e.properties[0].value
        $LogonID = $e.properties[2].value
    }

    $Properties = [ordered]@{
        'MachineName' = $e.MachineName
        'UserId' = $UserId
        'TimeCreated' = $e.TimeCreated
        'TaskDisplayName' = $e.TaskDisplayName
        'KeywordsDisplayNames' = "$($e.KeywordsDisplayNames)"
        'LogonID' = $LogonID
        'Id' = $e.Id
    }
    $LogDetails += New-Object -TypeName PSObject -Property $Properties
}

foreach ($Log in ($LogDetails | Where-Object {$_.UserId -ne "System" -and $_.Id -ne 4634 -and $_.Id -ne 4647})) {
    if ($Log.Id -eq 4624) {
        $LogonTime = $Log.TimeCreated
        $LogoutTime = ($LogDetails | Where-Object {($_.Id -eq 4634 -or $_.Id -eq 4647) -and ($_.LogonID -eq $log.LogonID)}).TimeCreated
    } else {
        $LogonTime = $Log.TimeCreated
        $LogoutTime = $null
    }
    $Properties = [ordered]@{
        'MachineName' = $Log.MachineName
        'UserId' = $Log.UserId
        'KeywordsDisplayNames' = "$($Log.KeywordsDisplayNames)"
        'LogonID' = $Log.LogonID
        'LogonTime' = $LogonTime
        'LogoutTime' = $LogoutTime
        'Id' = $Log.Id
    }
    $logInOut += New-Object -TypeName PSObject -Property $Properties
}
