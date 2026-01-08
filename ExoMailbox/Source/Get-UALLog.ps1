function Get-UnifiedAuditLogDays {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter()]
        [int]
        $SearchDays = 90,
        # Parameter help description
        [Parameter(Mandatory)]
        [string[]]
        $UserIds
    )
    
    begin {
        $StartDate = (Get-Date)
        $StopDate = $StartDate.AddDays(-($SearchDays))
    }
    
    process {
        $UAL = do {
            $EndDate = $StartDate
            $StartDate = $StartDate.AddDays(-10)
            Write-Progress -Activity "UAL Search" -Status "$($StartDate.Year)-$($StartDate.Month)-$($StartDate.Day) to $($EndDate.Year)-$($EndDate.Month)-$($EndDate.Day)" -Id 1
            Write-Verbose "$($StartDate.Year)-$($StartDate.Month)-$($StartDate.Day) to $($EndDate.Year)-$($EndDate.Month)-$($EndDate.Day)"
            $sessionID = (New-Guid).Guid
            $CounterB = 0
            $UALSearch = do {
                $CounterB++
                Write-Progress -Activity "10 day search" -Status "$($CounterB)" -PercentComplete (($CounterB / 10) * 100) -Id 2 -ParentId 1
                Write-Verbose "Search #$($CounterB)"
                $UnifiedAuditLog = Search-UnifiedAuditLog -StartDate $StartDate -EndDate $EndDate -SessionId $SessionID -SessionCommand ReturnLargeSet -ResultSize 5000 -Formatted -UserIds $UserIds
                Write-Verbose "Results $($UnifiedAuditLog.Count)"
                Write-Progress -Activity "Items found" -Status "$($UnifiedAuditLog.Count)" -Id 3 -ParentId 2
                $UnifiedAuditLog
            } while ($UnifiedAuditLog.count -gt 0 -and $CounterB -lt 10)
            Write-Host "10 Day search: $($UALSearch.Count)"
            $UALSearch
        } until ($StartDate -le $StopDate)
    }
    
    end {
        return $UAL
    }
}





