# Exchange Online Mailbox Functions

---

These functions automate tasks related to gathering details from Exchange Online mailboxes.

## Instructions

This module can be loaded as-is by importing ExoMailbox.psd1. This is mainly intended for development purposes.

```Powershell
Import-Module .\ExoMailbox.psd1
```

To speed up module load time and minimize the amount of files that needs to be signed, distributed and installed, this module contains a build script that will package up the module into three files:

- ExoMailbox.psd1
- ExoMailbox.psm1
- license.txt

To build the module, make sure you have the following pre-req modules:

- Pester (Required Version 5.3.0)
- InvokeBuild (Required Version 3.2.1)
- PowerShellGet (Required Version 1.6.0)
- ModuleBuilder (Required Version 1.0.0)
- PSScriptAnalyzer (Required Version 1.0.1)

Start the build by running the following command from the project root:

```powershell
Invoke-Build
```

This will package all code into files located in .\bin\ExoMailbox. That folder is now ready to be installed, copy to any path listed in you PSModulePath environment variable and you are good to go!

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

---
Maintained by Mike Hiersche
