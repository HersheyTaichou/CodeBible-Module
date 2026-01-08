$UAL = Import-Csv ""

$MAIPs = ("2601:18f:b00:13b0:40d3:9cc3:9aac:669b","2601:18f:b00:13b0:c8cb:a856:2785:858c","2601:18f:b00:13b0:6c31:b895:3aec:48ce","2601:18f:b00:13b0:7cae:d6d:3238:6fe2","2601:18f:b00:13b0:d183:8d72:a7a2:af6e","2601:18f:b00:13b0:31d3:a3c:1ebb:b9a7","73.182.146.133","2601:18f:b00:13b0:9983:111f:97c6:5a84","2601:18f:b00:13b0:208d:e72e:cab0:97f","216.193.128.18","2601:18f:b00:13b0:f481:689f:9832:286d","2601:18f:b00:13b0:7174:5963:562d:c664","2601:18f:b00:13b0:4936:879d:1c09:2bc","2601:18f:b00:13b0:184c:5f5e:160f:d878","2601:18f:b00:13b0:1038:4a43:f739:6752","2601:18f:b00:13b0:e88b:5cc4:519d:b8af","2601:18f:b00:13b0:4498:bc41:b4ec:4b6f","2601:18f:b00:13b0:9d7d:f905:c953:363a","2601:18f:b00:13b0:4c87:903a:bf72:c81b","2601:18f:b00:13b0:cc9b:82a3:6971:44d4","2601:18f:b00:13b0:cd0d:848b:d73:4a85","2601:18f:b00:13b0:3cd7:2d1:8a78:26cb","2601:18f:b00:13b0:3896:de62:9349:aef6","2601:18f:b00:13b0:2560:b15b:5bc8:cd87","2601:18f:b00:13b0:8549:44c1:2618:8733","2601:18f:b00:13b0:85a8:ef45:46c2:62b2","2601:18f:b00:13b0:8562:88d1:4d89:dbf5","2601:18f:b00:13b0:2967:ac25:8797:9b71","2601:18f:b00:13b0:18df:3bad:e6b:dac9","2601:18f:b00:13b0:e85d:f217:4f71:7199","2601:18f:b00:13b0:5d3a:8ebe:b806:cd85","2601:18f:b00:13b0:6c5b:a019:9ad9:68ad","2601:18f:b00:13b0:c8a1:ca91:40b5:9dd3","71.26.220.49","73.69.133.158","2601:18f:b80:2810:4da3:517f:be0e:8270","2601:18f:b80:2810:c524:c14f:745a:e089","205.166.145.253","2601:18f:b80:2810:ecb9:b4ec:da65:bb79","2601:18f:b80:2810:a1eb:252f:c30d:18ea","2601:18f:b80:2810:55da:792d:c168:5d61","2601:18f:b80:2810:6513:9890:55d8:3edf","2601:18f:b80:2810:3157:cbf4:ab64:ecd8","2601:18f:b80:2810:58e0:d186:72fd:4d59")


$UALExpanded = foreach ($entry in $UAL) {
    # Parse the JSON field
    $obj = ConvertFrom-Json $entry.AuditData | Select-Object UALRecordID,UALCreationDate,UALRecordType,UALOperation,UALUserID,*
    # Add domain metadata if needed
    $obj.UALRecordID = $entry.RecordID
    $obj.UALCreationDate = $entry.CreationDate
    $obj.UALRecordType = $entry.RecordType
    $obj.UALOperation = $entry.Operation
    $obj.UALUserID = $entry.UserID
    $obj
}

$sessionID = (New-Guid).Guid
$startDate = (Get-Date).AddDays(-30)
$endDate = (Get-Date)
$result = do {
    Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -SessionId $sessionId -SessionCommand ReturnLargeSet -ResultSize 5000 -Formatted
}while ($temp.count -gt 0)

$result.count

$StartDate = (Get-Date).AddDays(-10)
$EndDate = (Get-Date)

$StopDate = (Get-Date).AddDays(-89)

$UAL = do {
    $CounterA++
    Write-Progress -Activity "UAL Search" -Status "$($CounterA)" -Id 1
    $sessionID = (New-Guid).Guid
    $CounterB = 0
    $UALSearch = do {
        $CounterB++
        Write-Progress -Activity "10 day search" -Status "$($CounterB)" -PercentComplete (($CounterB / 10) * 100) -Id 2 -ParentId 1
        $UnifiedAuditLog = Search-UnifiedAuditLog -StartDate $StartDate -EndDate $EndDate -SessionId $SessionID -SessionCommand ReturnLargeSet -ResultSize 5000 -Formatted -UserIds lisa.cole@hawkpartners.com
        $UnifiedAuditLog
    } while ($UnifiedAuditLog.count -gt 0 -and $CounterB -lt 10)
    Write-Host "10 Day search: $($UALSearch.Count)"
    $UALSearch
    $EndDate = $StartDate
    $StartDate = $StartDate.AddDays(-10)

} until ($StartDate -le $StopDate)

$UAL = do {
    $sessionID = (New-Guid).Guid
    $Counter = 0
    $UALThirty = do {
        $Counter++
        Write-Progress -Activity "30 day search" -Status "$($Counter)" -PercentComplete (($Counter / 10) * 100)
        $UnifiedAuditLog = Search-UnifiedAuditLog -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date) -SessionId $SessionID -SessionCommand ReturnLargeSet -ResultSize 5000 -Formatted -UserIds lisa.cole@hawkpartners.com
        Write-Progress -Activity "30 day search" -Status "$($Counter) - $($UnifiedAuditLog.count )" -PercentComplete (($Counter / 10) * 100)
        $UnifiedAuditLog
    } while ($UnifiedAuditLog.count -gt 0 -and $Counter -lt 10)
    Write-Host "30 Day search: $($UALThirty.Count)"
    $UALThirty

    $sessionID = (New-Guid).Guid
    $Counter = 0
    $UALSixty = do {
        $Counter++
        Write-Progress -Activity "60 day search" -Status "$($Counter)" -PercentComplete (($Counter / 10) * 100)
        $UnifiedAuditLog = Search-UnifiedAuditLog -StartDate (Get-Date).AddDays(-60) -EndDate (Get-Date).AddDays(-30) -SessionId $SessionID -SessionCommand ReturnLargeSet -ResultSize 5000 -Formatted -UserIds lisa.cole@hawkpartners.com
        Write-Progress -Activity "60 day search" -Status "$($Counter) - $($UnifiedAuditLog.count )" -PercentComplete (($Counter / 10) * 100)
        $UnifiedAuditLog
    } while ($UnifiedAuditLog.count -gt 0 -and $Counter -lt 10)
    Write-Host "60 Day search: $($UALSixty.Count)"
    $UALSixty

    $sessionID = (New-Guid).Guid
    $Counter = 0
    $UALNinety = do {
        $Counter++
        Write-Progress -Activity "90 day search" -Status "$($Counter)" -PercentComplete (($Counter / 10) * 100)
        $UnifiedAuditLog = Search-UnifiedAuditLog -StartDate (Get-Date).AddDays(-90) -EndDate (Get-Date).AddDays(-60) -SessionId $SessionID -SessionCommand ReturnLargeSet -ResultSize 5000 -Formatted -UserIds lisa.cole@hawkpartners.com
        Write-Progress -Activity "90 day search" -Status "$($Counter) - $($UnifiedAuditLog.count )" -PercentComplete (($Counter / 10) * 100)
        $UnifiedAuditLog
    } while ($UnifiedAuditLog.count -gt 0 -and $Counter -lt 10)
    Write-Host "90 Day search: $($UALNinety.Count)"
    $UALNinety

} until ($true)
