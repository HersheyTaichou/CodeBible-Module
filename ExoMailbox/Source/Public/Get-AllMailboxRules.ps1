<#
.SYNOPSIS
Gather a report of all mailbox rules

.DESCRIPTION
This function will generate a report of all the mailboxes with the rules applied to each.

.EXAMPLE
Get-AllMailboxRules

.NOTES
General notes
#>
function Get-AllMailboxRules {
    [CmdletBinding()]
    param (
        # Get all the mailboxes, unless we specify only a few
        [Parameter()]
        [array]
        $mailboxes = $(Get-ExoMailbox -ResultSize Unlimited)
    )
    
    begin {
        try {
            $AllMailboxes = $mailboxes
        }
        catch {
            throw $_
        }
        
        $Return = @()
        $CounterA = 0
    }
    
    process {
        $Return = foreach ($Mailbox in $AllMailboxes) {
                $CounterA ++
                $ActivityA = "Processing " + $Mailbox.DisplayName
                Write-Progress -Id 0 -Activity $ActivityA -PercentComplete (($CounterA / $AllMailboxes.count) * 100)
                $Rules = Get-InboxRule -Mailbox $Mailbox.PrimarySmtpAddress
                if ($Rules) {
                    $CounterB = 0
                    foreach ($rule in $Rules) {
                        $ActivityB = "Processing " + $rule.DisplayName
                        $CounterB ++
                        Write-Progress -Id 1 -Activity $ActivityB -PercentComplete (($CounterB / $Rules.count) * 100) -ParentId 0
                        $Properties = [ordered]@{
                            'PrimarySmtpAddress' = $Mailbox.PrimarySmtpAddress
                            'DisplayName' = $Mailbox.DisplayName
                            'RecipientTypeDetails' = $Mailbox.RecipientTypeDetails
                            'Description' = $Rule.Description
                            'Enabled' = $Rule.Enabled
                            'Identity' = $Rule.Identity
                            'InError' = $Rule.InError
                            'ErrorType' = $Rule.ErrorType
                            'Name' = $Rule.Name
                            'Priority' = $Rule.Priority
                            'RuleIdentity' = $Rule.RuleIdentity
                            'SupportedByTask' = $Rule.SupportedByTask
                            'Legacy' = $Rule.Legacy
                            'BodyContainsWords' = $Rule.BodyContainsWords
                            'ExceptIfBodyContainsWords' = $Rule.ExceptIfBodyContainsWords
                            'FlaggedForAction' = $Rule.FlaggedForAction
                            'ExceptIfFlaggedForAction' = $Rule.ExceptIfFlaggedForAction
                            'FromAddressContainsWords' = $Rule.FromAddressContainsWords
                            'ExceptIfFromAddressContainsWords' = $Rule.ExceptIfFromAddressContainsWords
                            'From' = $Rule.From
                            'ExceptIfFrom' = $Rule.ExceptIfFrom
                            'HasAttachment' = $Rule.HasAttachment
                            'ExceptIfHasAttachment' = $Rule.ExceptIfHasAttachment
                            'HasClassification' = $Rule.HasClassification
                            'ExceptIfHasClassification' = $Rule.ExceptIfHasClassification
                            'HeaderContainsWords' = $Rule.HeaderContainsWords
                            'ExceptIfHeaderContainsWords' = $Rule.ExceptIfHeaderContainsWords
                            'MessageTypeMatches' = $Rule.MessageTypeMatches
                            'ExceptIfMessageTypeMatches' = $Rule.ExceptIfMessageTypeMatches
                            'MyNameInCcBox' = $Rule.MyNameInCcBox
                            'ExceptIfMyNameInCcBox' = $Rule.ExceptIfMyNameInCcBox
                            'MyNameInToBox' = $Rule.MyNameInToBox
                            'ExceptIfMyNameInToBox' = $Rule.ExceptIfMyNameInToBox
                            'MyNameInToOrCcBox' = $Rule.MyNameInToOrCcBox
                            'ExceptIfMyNameInToOrCcBox' = $Rule.ExceptIfMyNameInToOrCcBox
                            'MyNameNotInToBox' = $Rule.MyNameNotInToBox
                            'ExceptIfMyNameNotInToBox' = $Rule.ExceptIfMyNameNotInToBox
                            'ReceivedAfterDate' = $Rule.ReceivedAfterDate
                            'ExceptIfReceivedAfterDate' = $Rule.ExceptIfReceivedAfterDate
                            'ReceivedBeforeDate' = $Rule.ReceivedBeforeDate
                            'ExceptIfReceivedBeforeDate' = $Rule.ExceptIfReceivedBeforeDate
                            'RecipientAddressContainsWords' = $Rule.RecipientAddressContainsWords
                            'ExceptIfRecipientAddressContainsWords' = $Rule.ExceptIfRecipientAddressContainsWords
                            'SentOnlyToMe' = $Rule.SentOnlyToMe
                            'ExceptIfSentOnlyToMe' = $Rule.ExceptIfSentOnlyToMe
                            'SentTo' = $Rule.SentTo
                            'ExceptIfSentTo' = $Rule.ExceptIfSentTo
                            'SubjectContainsWords' = $Rule.SubjectContainsWords
                            'ExceptIfSubjectContainsWords' = $Rule.ExceptIfSubjectContainsWords
                            'SubjectOrBodyContainsWords' = $Rule.SubjectOrBodyContainsWords
                            'ExceptIfSubjectOrBodyContainsWords' = $Rule.ExceptIfSubjectOrBodyContainsWords
                            'WithImportance' = $Rule.WithImportance
                            'ExceptIfWithImportance' = $Rule.ExceptIfWithImportance
                            'WithinSizeRangeMaximum' = $Rule.WithinSizeRangeMaximum
                            'ExceptIfWithinSizeRangeMaximum' = $Rule.ExceptIfWithinSizeRangeMaximum
                            'WithinSizeRangeMinimum' = $Rule.WithinSizeRangeMinimum
                            'ExceptIfWithinSizeRangeMinimum' = $Rule.ExceptIfWithinSizeRangeMinimum
                            'WithSensitivity' = $Rule.WithSensitivity
                            'ExceptIfWithSensitivity' = $Rule.ExceptIfWithSensitivity
                            'ApplyCategory' = $Rule.ApplyCategory
                            'ApplySystemCategory' = $Rule.ApplySystemCategory
                            'CopyToFolder' = $Rule.CopyToFolder
                            'DeleteMessage' = $Rule.DeleteMessage
                            'DeleteSystemCategory' = $Rule.DeleteSystemCategory
                            'ForwardAsAttachmentTo' = $Rule.ForwardAsAttachmentTo
                            'ForwardTo' = $Rule.ForwardTo
                            'MarkAsRead' = $Rule.MarkAsRead
                            'MarkImportance' = $Rule.MarkImportance
                            'MoveToFolder' = $Rule.MoveToFolder
                            'PinMessage' = $Rule.PinMessage
                            'RedirectTo' = $Rule.RedirectTo
                            'SendTextMessageNotificationTo' = $Rule.SendTextMessageNotificationTo
                            'SoftDeleteMessage' = $Rule.SoftDeleteMessage
                            'StopProcessingRules' = $Rule.StopProcessingRules
                            'MailboxOwnerId' = $Rule.MailboxOwnerId
                            'IsValid' = $Rule.IsValid
                            'ObjectState' = $Rule.ObjectState
                        }
                        New-Object -TypeName PSObject -Property $Properties
                    }
                }
            }
            
        }
    
    end {
        return $Return
    }
}
