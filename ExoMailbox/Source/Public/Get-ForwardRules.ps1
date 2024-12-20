<#
.SYNOPSIS
Get Any Outlook Rules to Forward Emails

.DESCRIPTION
Searches each mailbox and returns any rules to forward emails. It will retrieve all forwards by default but can be restricted to external forwards only

.PARAMETER mailboxes
This takes an array of Get-ExoMailbox results, for when we we only want to check a few mbs.

.PARAMETER OnlyExternal
This will restrict the results to only external recipients.

.EXAMPLE
Get-ForwardRules

DisplayName: Example Rule
RuleId: 123
RuleName: Example Rule
RuleDescription: This is an example rule
ForwardRecipients: mb@domain.com

.NOTES
General notes
#>
function Get-ForwardRules {
    [CmdletBinding()]
    param (
        # Get all the mailboxes, unless we specify only a few
        [Parameter()]
        [array]
        $mailboxes = $(Get-ExoMailbox -ResultSize Unlimited),
        # Only show emails forwarded externally
        [Parameter()]
        [switch]
        $OnlyExternal
        
    )
    
    begin {
        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $RuleArray = @()
        $i = 0
    }
    
    process {
        # Get all the internal domains
        ## This is used to compare the recipient domain against, when checking to see if it is forwarding externally.
        try {
            $AcceptedDomain = (Get-AcceptedDomain)
        }
        catch [Exception] {
            Write-Error "Unable to determine the accepted domains. You must call Connect-ExchangeOnline before calling any other cmdlet."
            throw $_
        }
        $RuleArray = foreach ($mailbox in $mailboxes) {
            $i ++
            Write-Progress -Id 0 -Activity "Checking rules for $($mailbox.DisplayName)" -Status "Progress:" -PercentComplete (($i/$mailboxes.count) * 100)
            Write-Verbose "Checking rules for $($mailbox.DisplayName)"
            $forwardingRules = Get-InboxRule -Mailbox $mailbox.primarysmtpaddress | Where-Object {$_.forwardto -or $_.forwardasattachmentto}
            $ii = 0
            foreach ($rule in $forwardingRules) {
                $ii ++
                Write-Progress -Id 1 -Activity "Checking Forward rules for $($mailbox.DisplayName)" -Status "Progress:" -PercentComplete (($ii/$forwardingRules.count) * 100) -ParentId 0
                [array]$recipients = $rule.ForwardTo | Where-Object {$_ -match "SMTP"}
                $recipients += $rule.ForwardAsAttachmentTo | Where-Object {$_ -match "SMTP"}
                $FwdRecipients = foreach ($recipient in $recipients) {
                    $email = ($recipient -split "SMTP:")[1].Trim("]")
                    $domain = ($email -split "@")[1]
                    if (($AcceptedDomain.DomainName -notcontains $domain) -and $OnlyExternal) {
                        $email
                    } else {
                        $email
                    }
                }

                if ($FwdRecipients) {
                    $FwdRecString = $FwdRecipients -join ", "
                    Write-Warning "$($rule.Name) forwards to $FwdRecString"
                    [ordered]@{
                        PrimarySmtpAddress = $mailbox.PrimarySmtpAddress
                        DisplayName        = $mailbox.DisplayName
                        RuleId             = $rule.Identity
                        RuleName           = $rule.Name
                        RuleDescription    = $rule.Description
                        ForwardRecipients = $FwdRecString
                    }
                }
            }
        }
    }
    
    end {
        $Stopwatch.Stop
        Write-Verbose "Total time elapsed: $([math]::Round($stopwatch.Elapsed.TotalSeconds,0)) seconds"
        return $RuleArray
    }
}
