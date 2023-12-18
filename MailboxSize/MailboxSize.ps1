<#
.SYNOPSIS
Runs a Report on Mailbox Sizes

.DESCRIPTION
Runs a report on mailbox sizes. The report can be for one mailbox, or all mailboxes

.PARAMETER AllMailboxes
Parameter description

.PARAMETER Mailbox
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-MailboxSize {
    [CmdletBinding()]
    param (
        # Get a report on all mailboxes
        [Parameter(ParameterSetName='All',Mandatory=$true)]
        [switch]
        $AllMailboxes,
        # One email address to check
        [Parameter(ParameterSetName='Single',Mandatory=$true)]
        [string[]]
        $Mailbox
    )
    
    begin {
        if ($AllMailboxes) {
            $Mailboxes = Get-Mailbox
        } else {
            $Mailboxes = Get-Mailbox -Identity $Mailbox
        }
        $Return = @()
    }
    
    process {
        
        foreach ($MB in $Mailboxes) {
            $MbStats = Get-MailboxStatistics -Identity $MB.Id
            $Details = [ordered]@{
                'DisplayName' = $MB.DisplayName
                'PrimarySmtpAddress' = $MB.PrimarySmtpAddress
                'Database' = $MB.Database.Name
                'TotalItemSize' = $MbStats.TotalItemSize
            }
            $Return += New-Object -TypeName PSObject -Property $Details
        }
    }
    
    end {
        return $Return
    }
}