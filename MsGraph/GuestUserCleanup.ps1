<#
.SYNOPSIS
Remove Guest Users from Azure

.DESCRIPTION
This script will remove guest users from Azure that have not signed in for the last $Age days, and were created more than $Age days ago. It will also create a report listing all the users that are to be cleaned up

.PARAMETER Age
The age of the accounts to delete. Can be passed as a positive or negative integer, as long as it is not 0

.PARAMETER TenantId
The ID for the Microsoft Tenant

.PARAMETER Remove
This is a switch to enable live delete mode. Otherwise it defaults to -WhatIf mode. 

.EXAMPLE
This will output a report listing the users to be deleted and will test the removal with the -WhatIf flag.

Remove-OldGuestUsers -Age 90 -TenantID $ID

.EXAMPLE
This will output a report listing the users to be deleted and will then remove all the users listed in the report.

Remove-OldGuestUsers -Age 90 -TenantID $ID -Cleanup

.NOTES
General notes
#>
function Remove-OldGuestUsers {
    [CmdletBinding()]
    param (
        # Age of accounts to remove
        [Parameter(Mandatory)]
        [int]
        $Age,
        # Office 365 Tenant ID
        [Parameter(Mandatory)]
        [string]
        $TenantId,
        # Live cleanup mode
        [Parameter()]
        [switch]
        $Remove
    )
    
    begin {
        Connect-MgGraph -Scopes "User.ReadWrite.All" -TenantId $TenantId -NoWelcome
        if ($Age -gt 0) {
            $Age = 0 - $Age
        } elseif ($Age -lt 0){
            # Age is already negative
        } else {
            Write-Error "Age variable is 0. Check the value and try again"
            exit
            Read-Host -Prompt "Enter a negative number of days, any guest accounts that have not signed in for that number of days will be disabled"
        }
    }
    
    process {
        $GuestUsers = Get-MgBetaUser -all -Select SignInActivity | Where-Object {$_.UserType -eq "Guest"}
        Write-Verbose "Number of guest accounts: $($GuestUsers.Count)"
        $CleanupGuests = $GuestUsers | Where-Object {$_.CreatedDateTime -le (Get-Date).AddDays($Age) -and $_.SignInActivity.LastSuccessfulSignInDateTime -le (Get-Date).AddDays($Age)} | Select-Object -ExpandProperty SignInActivity AccountEnabled,CreatedDateTime,CreationType,DisplayName,ExternalUserState,ExternalUserStateChangeDateTime,Id,Mail,MailNickname,SecurityIdentifier,SignInSessionsValidFromDateTime,UserPrincipalName,UserType,Result
        Write-Verbose "Number of guest accounts to cleanup: $($CleanupGuests.Count)"
        $DeleteGuests = $CleanupGuests | where-object {$_.AccountEnabled -eq $false}
        Write-Verbose "Number of guest accounts to remove: $($DeleteGuests.Count)"
        $DisableGuests = $CleanupGuests | where-object {$_.AccountEnabled -eq $true}
        Write-Verbose "Number of guest accounts to disable: $($DisableGuests.Count)"
        $Return = foreach ($Guest in $DeleteGuests) {
            $DeleteCounter++
            Write-Progress -Activity "Deleting User" -Status $Guest.UserPrincipalName -PercentComplete (($DeleteCounter / $DeleteGuests.Count) * 100)
            $Guest.Result = "Deleted"
            if ($Remove) {
                Remove-MgUser -UserId $Guest.Id
            }
            $Guest
        }
        $Return += foreach ($Guest in $DisableGuests) {
            $DisableCounter++
            Write-Progress -Activity "Disabling User" -Status $Guest.UserPrincipalName -PercentComplete (($DisableCounter / $DisableGuests.Count) * 100)
            $Guest.Result = "Disabled"
            if ($Remove) {
                Update-MgUser -UserId $Guest.Id -AccountEnabled:$false
            }
            $Guest
        }
    }

    end {
        return $Return
    }
}
