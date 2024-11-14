# Exchange Online Mailbox Functions

These functions automate tasks related to gathering details from Exchange Online mailboxes.

Before you can run any of these commands, you will need to import the module

```Powershell
Import-Module .\ExoMailbox.psd1
```

## Get-AllMailboxRules Function

This function will export a report of all the rules in all the mailboxes, so you can check for any suspicious or not allowed rules.

### Get-AllMailboxRules Example

First, you will need to connect to Exchange Online

```Powershell
Connect-ExchangeOnline -DelegatedOrganization "domain.onmicrosoft.com"
```

Then you can run the function. Unless you want the results returned to the terminal, make sure to either store them in a variable or redirect them to a file.

Storing in a variable, then exporting:

```PowerShell
$AllMailboxRules = Get-AllMailboxRules
$AllMailboxRules | Export-Csv .\AllMailboxRules.csv
```

Export straight to a file:

```PowerShell
Get-AllMailboxRules | Export-Csv .\AllMailboxRules.csv
```

## Get-ForwardRules Function

This function can search for and create a report on any rules that will forward emails to another mailbox

### Get-ForwardRules Parameters

#### -Mailboxes \<array[]\>

This accepts an array of mailbox objects, as retuned by Get-ExoMailbox. If not specified, it defaults to all mailboxes

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Accept pipeline input? | false |

#### -OnlyExternal \<Switch\>

This toggles if all forwarding rules should be included, or only rules forwarding externally.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Accept pipeline input? | false |

### Get-ForwardRules Example

This will get all forwarding rules for all mailboxes across the tenant. We will want to store the results in a variable, otherwise they will print to the screen

```PowerShell
$ForwardRules = Get-ForwardRules
$ForwardRules | Export-Csv .\ForwardRules.csv
```

This will get only rules forwarding email externally

```PowerShell
$ForwardRules = Get-ForwardRules -OnlyExternal
$ForwardRules | Export-Csv .\ForwardRules.csv
```
