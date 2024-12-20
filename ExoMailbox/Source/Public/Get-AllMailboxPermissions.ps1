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
