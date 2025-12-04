# Remove-OldGuestUsers Command

This script will remove guest users from Azure that have not signed in for the last $Age days, and were created more than $Age days ago. It will also create a report listing all the users that are to be cleaned up

## Requirements

This module requires the Microsoft Graph Beta module to work correctly

## Usage

Before you can run this command, you will need to install the Microsoft.Graph.Beta module:

```PowerShell
Install-Module Microsoft.Graph.Beta
```

Then you will need to connect:

```PowerShell
Connect-MgGraph -Scopes "User.ReadWrite.All" -TenantId $TenantId -NoWelcome
```

## Parameters

### PARAMETER Age

The age of the accounts to delete. Can be passed as a positive or negative integer, as long as it is not 0

## Examples

### Example 1

```PowerShell
Remove-OldGuestUsers -Age 90 -WhatIF
What if: Performing the operation "Remove-MgBetaUser" on target "user@guestdomain.com".
What if: Performing the operation "Remove-MgBetaUser" on target "user@externaldomain.com".
```

This will show you a list of the users that would have been deleted, then return a report of the users.

### Example 2

```PowerShell
Remove-OldGuestUsers -Age 90 -WhatIf | Export-Csv GuestUsersToDelete.csv
What if: Performing the operation "Remove-MgBetaUser" on target "user@guestdomain.com".
What if: Performing the operation "Remove-MgBetaUser" on target "user@externaldomain.com".
```

This is the same as above, but will save the report as a CSV.

### Example 3

```PowerShell
Remove-OldGuestUsers -Age 90

Confirm
Are you sure you want to perform this action?
Performing the operation "Remove-MgBetaUser" on target "user@guestdomain.com".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
```

This will have you confirm each user to be deleted, then return a report of the users.

### Example 4

```PowerShell
Remove-OldGuestUsers -Age 90 | Export-Csv GuestUsersToDelete.csv

Confirm
Are you sure you want to perform this action?
Performing the operation "Remove-MgBetaUser" on target "user@guestdomain.com".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
```

This is the same as above, but will save the report as a CSV.

### Example 5

```PowerShell
Remove-OldGuestUsers -Age 90 -Confirm:$false
```

This will remove all the users without confirming each one.

### Example 6

```PowerShell
Remove-OldGuestUsers -Age 90 -Confirm:$false | Export-Csv GuestUsersToDelete.csv
```

This is the same as above, but will save the report as a CSV.
