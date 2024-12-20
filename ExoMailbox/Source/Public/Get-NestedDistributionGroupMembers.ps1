<#
.SYNOPSIS
Get all members of a distribution group

.DESCRIPTION
This script will get all members of a distribution group, including members nested in groups under the main group. It will filter out any duplicate entries, if a user is a member of multiple nested groups.

.PARAMETER Identity
The identity of the group

.EXAMPLE
$Members = Get-NestedDistributionGroupMembers - Identity "company@domain.com"

This will get all the members of company@domain.com including groups under it and store the list of members in $Members

.NOTES
General notes
#>
function Get-NestedDistributionGroupMembers {
    [CmdletBinding()]
    param (
        # The email address for the top group
        [Parameter(Mandatory)]
        [string]
        $Identity
    )
    
    begin {
        $Identity = Get-DistributionGroup -Identity $Identity
        $NestedGroups = Get-DistributionGroupMember -Identity $Identity -ResultSize Unlimited | Where-Object {$_.RecipientType -eq "MailUniversalDistributionGroup"}
    }
    
    process {
        $Level = 1
        $NestedMembers = do {
            $Counter = 1
            $NewNestedGroups = @()
            Foreach ($DL in $NestedGroups) {
                Write-Progress -Activity "Getting groups under $($DL.Name)" -PercentComplete ($counter / $NestedGroups.count * 100) -Id 0 -Status "On group number $counter of $($NestedGroups.count)"
                $Group = Get-DistributionGroupMember -Identity $DL
                $Group | Where-Object {$_.RecipientType -ne "MailUniversalDistributionGroup"}
                $NewNestedGroups += $Group | Where-Object {$_.RecipientType -eq "MailUniversalDistributionGroup"}
            }
            $NestedGroups = $NewNestedGroups
            $Level++
        } while ($NestedGroups.count -gt 0 -and $level -lt 10)
    }
    
    end {
        return $NestedMembers | Sort-Object PrimarySmtpAddress | Get-Unique -AsString
    }
}
