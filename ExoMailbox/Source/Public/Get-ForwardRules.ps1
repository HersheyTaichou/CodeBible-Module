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
        $RuleArray = @()
        $i = 0
        # Import-Module -Name ExchangeOnlineManagement
    }
    
    process {
        # Get all the internal domains
        ## This is used to compare the recipient domain against, when checking to see if it is forwarding externally.
        try {
            $AcceptedDomain = (Get-AcceptedDomain)
        }
        catch [Exception] {
            $Message = "Unable to determine the accepted domains. You must call Connect-ExchangeOnline before calling any other cmdlet."
            Write-Error $Message
            return
        }
        $RuleArray = foreach ($mailbox in $mailboxes) {
            $i ++
            Write-Progress -id 0 -Activity "Checking rules for $($mailbox.DisplayName)" -Status "Progress:" -PercentComplete (($i/$mailboxes.count) * 100)
            $forwardingRules = $null
            Write-Verbose "Checking rules for $($mailbox.DisplayName) - $($mailbox.PrimarySmtpAddress)"
            $rules = get-inboxrule -Mailbox $mailbox.primarysmtpaddress
            Write-Verbose "$($mailbox.DisplayName) - $($mailbox.PrimarySmtpAddress) has $($rules.count) rules"
            $forwardingRules = $rules | Where-Object {$_.forwardto -or $_.forwardasattachmentto}
            Write-Verbose "$($mailbox.DisplayName) - $($mailbox.PrimarySmtpAddress) has $($forwardingRules.count) forwarding rules"
            $ii = 0
            foreach ($rule in $forwardingRules) {
                $ii ++
                Write-Progress -id 1 -Activity "Checking Forward rules for $($mailbox.DisplayName)" -Status "Progress:" -PercentComplete (($ii/$forwardingRules.count) * 100)
                [array]$recipients = $rule.ForwardTo | Where-Object {$_ -match "SMTP"}
                $recipients += $rule.ForwardAsAttachmentTo | Where-Object {$_ -match "SMTP"}
             
                $FwdRecipients = @()
         
                foreach ($recipient in $recipients) {
                    $email = ($recipient -split "SMTP:")[1].Trim("]")
                    $domain = ($email -split "@")[1]
        
                    if (($AcceptedDomain.DomainName -notcontains $domain) -and $OnlyExternal) {
                        $FwdRecipients += $email
                    } else {
                        $FwdRecipients += $email
                    }
                }

                if ($FwdRecipients) {
                    $FwdRecString = $FwdRecipients -join ", "
                    Write-Warning "$($rule.Name) forwards to $FwdRecString"

                    $ruleHash = $null
                    $ruleHash = [ordered]@{
                        PrimarySmtpAddress = $mailbox.PrimarySmtpAddress
                        DisplayName        = $mailbox.DisplayName
                        RuleId             = $rule.Identity
                        RuleName           = $rule.Name
                        RuleDescription    = $rule.Description
                        ForwardRecipients = $FwdRecString
                    }
                    $ruleHash
                }
            }
        }
    }
    
    end {
        return $RuleArray
    }
}
