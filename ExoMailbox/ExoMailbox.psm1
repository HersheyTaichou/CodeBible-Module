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
    param ()
    
    begin {
        try {
            $AllMailboxes = Get-EXOMailbox -ResultSize Unlimited
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
        
        $Return = foreach ($MB in $Mailboxes) {
            $MbStats = Get-MailboxStatistics -Identity $MB.Id
            $Details = [ordered]@{
                'DisplayName' = $MB.DisplayName
                'PrimarySmtpAddress' = $MB.PrimarySmtpAddress
                'Database' = $MB.Database.Name
                'TotalItemSize' = $MbStats.TotalItemSize
            }
            New-Object -TypeName PSObject -Property $Details
        }
    }
    
    end {
        return $Return
    }
}

<#
.SYNOPSIS
Get all permissions to a mailbox

.DESCRIPTION
This function will return the permissions for folders under user mailboxes. You can get a report on an array of mailboxes or on all mailboxes in the tenant. 

.PARAMETER AllMailboxes
When this switch is active, it will return permissions to the select folders for all mailboxes

.PARAMETER Mailbox
This will take an array of emails, and return the permissions for all of them. 

.PARAMETER mbFolders
This defines the list of folders to return permissions for. This will default to the root, Calendar and Contact folders.

.EXAMPLE
Get-AllMailboxPermissions -AllMailboxes | Export-Csv .\MailboxPermissions.csv

This command will return a csv file with the permissions for every mailbox in the tenant. 

.NOTES
General notes
#>
function Get-AllMailboxPermissions {
    [CmdletBinding()]
    param (
        # Get a report on all mailboxes
        [Parameter(ParameterSetName='All',Mandatory=$true)]
        [switch]
        $AllMailboxes,
        # A limited array of emails to check
        [Parameter(ParameterSetName='Single',Mandatory=$true)]
        [string[]]
        $Mailbox,
        [Parameter()]
        [string[]]
        $mbFolders = @(":\",":\Calendar",":\Contacts")
    )
    
    begin {
        if ($AllMailboxes) {
            $Mailboxes = Get-ExoRecipient -ResultSize:Unlimited
        } else {
            $Mailboxes = $Mailbox | ForEach-Object {Get-ExoRecipient -Identity $_}
        }
        $Counter=0
    }

    Process {
        $allmbDetails = ForEach ($mb in $Mailboxes) {
            $Counter++
            Write-Progress -Id 0 -Activity "Gathering Details" -Status "$($mb.DisplayName)" -PercentComplete (($Counter / $Mailboxes.count) * 100)
            $CounterA = 0
            foreach ($Folder in $mbFolders) {
                $CounterA++
                Write-Progress -Id 1 -ParentId 0 -Activity "Checking Folders" -Status "$($Folder)" -PercentComplete (($CounterA / $mbFolders.count) * 100)
                $FolderPerms = Get-EXOMailboxFolderPermission -Identity "$($mb.Identity)$($Folder)" -ErrorAction SilentlyContinue
                if ($null -ne $FolderPerms) {
                    foreach ($Permision in $FolderPerms) {
                        $Properties = [ordered]@{
                            'Identity' = $mb.Identity;
                            'DisplayName' = $mb.DisplayName;
                            'PrimarySmtpAddress' = $mb.PrimarySmtpAddress;
                            'RecipientTypeDetails' = $mb.RecipientTypeDetails;
                            'FolderName' = $Permision.FolderName;
                            'User' = $Permision.User;
                            'AccessRights' = $Permision.AccessRights -join ";";
                            'SharingPermissionFlags' = $Permision.SharingPermissionFlags;
                        }
                    }
                    New-Object -TypeName PSObject -Property $Properties
                }
            }
        }
    }

    end {
        return $allmbDetails
    }
}

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
