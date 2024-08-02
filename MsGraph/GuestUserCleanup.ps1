<#
.SYNOPSIS
Remove Guest Users from Azure

.DESCRIPTION
This script will remove guest users from Azure that have not signed in for the last $Age days, and were created more than $Age days ago. It will also create a report listing all the users that are to be cleaned up

.PARAMETER Age
The age of the accounts to delete. Can be passed as a positive or negative integer, as long as it is not 0

.PARAMETER TenantId
The ID for the Microsoft Tenant

.PARAMETER Cleanup
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
        [bool]
        $Cleanup
    )
    
    begin {
        Connect-MgGraph -Scopes "User.ReadWrite.All" -TenantId $TenantId
        if ($Age -gt 0) {
            $Age = 0 - $Age
        } elseif ($Age -lt 0){
            # Age is already negative
        } else {
            Write-Error "Age variable is 0. Check the value and try again"
            exit
        }
    }
    
    process {
        $Guests = Get-MgBetaUser -all -Select SignInActivity | Where-Object {$_.UserType -eq "guest" -and $_.CreatedDateTime -le (Get-Date).AddDays($Age) -and $_.SignInActivity.LastSuccessfulSignInDateTime -le (Get-Date).AddDays($Age)}
        $Guests | Select-Object -ExpandProperty SignInActivity AccountEnabled,CreatedDateTime,CreationType,DisplayName,ExternalUserState,ExternalUserStateChangeDateTime,Id,Mail,MailNickname,SecurityIdentifier,SignInSessionsValidFromDateTime,UserPrincipalName,UserType | Export-Csv 'Guest-User-Cleanup.csv'
        if ($Cleanup) {
            $Guests | ForEach-Object {
                Remove-MgUser -UserId $_.Id
            }
        } else {
            $Guests | ForEach-Object {
                Remove-MgUser -UserId $_.Id -WhatIf
            }
        }
    }

}