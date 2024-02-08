<#
.SYNOPSIS
Base Function for Event Log Searches

.DESCRIPTION
This function provides a base with the common commands to get an export of logs based on Event IDs

.PARAMETER InstanceID
Array of Event IDs to filter by

.PARAMETER Before
Seach before this date

.PARAMETER After
Seach after this date

.EXAMPLE
An example

.NOTES
This command should be internal only
#>
function Get-FilteredEventLog {
    [CmdletBinding()]
    param (
        # Array of Event IDs to filter by
        [Parameter(Mandatory)]
        [Int[]]
        $InstanceID,
        # Seach before this date
        [Parameter()]
        [datetime]
        $Before,
        # Search after this date
        [Parameter()]
        [datetime]
        $After
    )
    
    begin {
        $Parameters = @{
            "InstanceId" = $InstanceID
            "LogName"    = "Security"
        }
        if ($Before) {
            $Parameters += @{
                "Before" = $Before
            }
        }

        if ($After) {
            $Parameters += @{
                "After" = $After
            }
        }
    }

    process {
        $FilteredLogs = Get-EventLog @Parameters
    }
    
    end {
        return $FilteredLogs
    }
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
This function gathers logs for each event of user account management, such as when a user account is created, changed, or deleted; a user account is renamed, disabled, or enabled; or a password is set or changed. 

Events searched include:

- 4720: A user account was created.
- 4722: A user account was enabled.
- 4723: An attempt was made to change an account's password.
- 4724: An attempt was made to reset an account's password.
- 4725: A user account was disabled.
- 4726: A user account was deleted.
- 4738: A user account was changed.
- 4740: A user account was locked out.
- 4765: SID History was added to an account.
- 4766: An attempt to add SID History to an account failed.
- 4767: A user account was unlocked.
- 4780: The ACL was set on accounts which are members of administrators groups.
- 4781: The name of an account was changed:
- 4794: An attempt was made to set the Directory Services Restore Mode.
- 5376: Credential Manager credentials were backed up.
- 5377: Credential Manager credentials were restored from a backup.

.PARAMETER Before
Search before this date

.PARAMETER After
Search after this date

.EXAMPLE
Get-EventLogUserAccountManagement

This will return a list of results found

.EXAMPLE
Get-EventLogUserAccountManagement -After (Get-Date "2023-01-01 12:00:00") -Before (Get-Date "2023-03-01 12:00:00")

This will return a list of results found between January 1st and the end of February, 2023

.NOTES
General notes
#>
function Get-EventLogUserAccountManagement {
    [CmdletBinding()]
    param (
        # Seach before this date
        [Parameter()]
        [datetime]
        $Before,
        # Search after this date
        [Parameter()]
        [datetime]
        $After
    )
    
    begin {
        $Parameters = @{
            "InstanceId" = @(4720,4722,4723,4724,4725,4726,4738,4740,4765,4766,4767,4780,4781,4794,5376,5377)
        }
        if ($Before) {
            $Parameters += @{
                "Before" = $Before
            }
        }

        if ($After) {
            $Parameters += @{
                "After" = $After
            }
        }
    }
    
    process {
        $UserAccountManagement = Get-FilteredEventLog @Parameters
    }
    
    end {
        return $UserAccountManagement
    }
}

function Get-EventLogBitlocker {
    [CmdletBinding()]
    param (
        # Get only logs before this date
        [Parameter()]
        [datetime]
        $Before,
        # Get only logs after this date
        [Parameter()]
        [datetime]
        $After
    )
    
    begin {
        $After = Get-Date -Date "2024-01-02 00:00:00"
        $EventLogs =  Get-WinEvent -LogName "Microsoft-Windows-BitLocker/BitLocker Management" -ErrorAction SilentlyContinue
        $EventLogs +=  Get-WinEvent -LogName "Microsoft-Windows-BitLocker/BitLocker Operational" -ErrorAction SilentlyContinue
        $EventLogs +=  Get-WinEvent -LogName "Microsoft-Windows-BitLocker-DrivePreparationTool/Admin" -ErrorAction SilentlyContinue
        $EventLogs +=  Get-WinEvent -LogName "Microsoft-Windows-BitLocker-DrivePreparationTool/Operational" -ErrorAction SilentlyContinue
    }
    
    process {
        if ($Before) {
            $EventLogs = $EventLogs | Where-Object {(Get-Date -Date $_.TimeCreated) -le $Before}
        }

        if ($After) {
            $EventLogs = $EventLogs | Where-Object {(Get-Date -Date $_.TimeCreated) -ge $After}
        }

        $EventLogs = $EventLogs | Sort-Object TimeCreated
    }
    
    end {
        return $FilteredLogs
    }
}
