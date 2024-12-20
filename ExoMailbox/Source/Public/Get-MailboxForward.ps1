<#
.SYNOPSIS
Get mailboxes with a forward setup

.DESCRIPTION
Searches all mailboxes for any that have a forward setup, then returns details on those mailboxes

.PARAMETER All
Check all mailboxes

.PARAMETER Identity
Check one or more mailboxes. This parameter takes an array of email addresses. 

.EXAMPLE
Get-MailboxForward -All

DisplayName                : Test User
UserPrincipalName          : Test.User@oriontech.info
ForwardingSmtpAddress      : smtp:personal.email@domain.com
DeliverToMailboxAndForward : True
RecipientTypeDetails       : UserMailbox

.NOTES
General notes
#>
function Get-MailboxForward {
    [CmdletBinding()]
    param (
        # Get all forwards
        [Parameter(ParameterSetName='All',Mandatory=$true)]
        [switch]
        $All,
        # Get forwards for specific user(s)
        [Parameter(ParameterSetName='Some',Mandatory=$true)]
        [string[]]
        $Identity
    )

    begin {
        try {
            if ($All) {
                $EXOMailboxes = Get-EXOMailbox -ResultSize Unlimited -PropertySets Minimum,Delivery
            } else {
                $EXOMailboxes = $Identity | ForEach-Object {Get-EXOMailbox -Identity $_ -PropertySets Minimum,Delivery}
            }
        }
        catch {
            Write-Error "Unable to gather the mailboxes. Have you run Connect-ExchangeOnline?"
            throw $_
        }
    }

    process {
        $UsersWithForwards = $EXOMailboxes | Where-Object {$Null -ne $_.ForwardingSmtpAddress} | Select-Object DisplayName,UserPrincipalName,ForwardingSmtpAddress,DeliverToMailboxAndForward,RecipientTypeDetails
    }

    end {
        return $UsersWithForwards
    }
}
