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
