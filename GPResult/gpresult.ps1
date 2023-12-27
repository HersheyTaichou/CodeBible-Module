#Requires -RunAsAdministrator
<#
.SYNOPSIS
Return an array of the current Group Policy Settings

.DESCRIPTION
Run gpresult.exe on the machine, then take the file output, import it as an XML variable, organize everything into an array and return the array.

.PARAMETER System
Specifies the remote system to connect to.

-System system

.PARAMETER Credentials
Specifies the user context under which the command should run.

-Credentials (Get-Credentials)

.PARAMETER Scope
Specifies whether the user or the computer settings need to be displayed. 

Valid values: "USER", "COMPUTER".

.PARAMETER User
Specifies the user name for which the RSoP data is to be displayed.

-User [domain\]user

.PARAMETER XML
Saves the report in XML format.

-XML

.PARAMETER HTML
Saves the report in HTML format.

-HTML

.PARAMETER PATH
Specifices where to save the report.

-PATH <filename>

.PARAMETER Array
Return the report as an array.

.PARAMETER Force
Forces Gpresult to overwrite the file name specified in the -XML or -HTML command.

.PARAMETER RSoP
Displays RSoP summary data.

.PARAMETER SuperVerbose
Specifies that the super-verbose information should be displayed. 

Super-verbose information provides additional detailed settings that have been applied with a precedence of 1 and higher. This allows you to see if a setting was set in multiple places.

.EXAMPLE
Get-GPResult

Policy                                Setting GPO        Path
------                                ------- ---        ----
Audit Directory Service Changes       Success GPObject Policies/Windows Settings/Security Settings/Advanced Audit Co…
Audit Logon                           Success GPObject Policies/Windows Settings/Security Settings/Advanced Audit Co…
Audit Sensitive Privilege Use         Success GPObject Policies/Windows Settings/Security Settings/Advanced Audit Co…
Audit Kerberos Authentication Service Success GPObject Policies/Windows Settings/Security Settings/Advanced Audit Co…
Audit Other Account Management Events Success GPObject Policies/Windows Settings/Security Settings/Advanced Audit Co…

.NOTES
TODO:
- Add standard GPResult.exe options
#>
function Get-GPResult {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        # Specifies the remote system to connect to.
        [Parameter()][string]$System,
        # Specifies the user context under which the command should run.
        [Parameter(ParameterSetName='Default')][pscredential]$Credentials,
        # Specifies whether the user or the computer settings need to be displayed.
        [Parameter()][ValidateSet("User","Computer")][string]$Scope,
        # Specifies the user name for which the RSoP data is to be displayed.
        [Parameter()][string]$User,
        # Saves the report in XML format at the location and with the file name specified.
        [Parameter(Mandatory,ParameterSetName='XML')][switch]$XML,
        # Saves the report in HTML format at the location and with the file name specified.
        [Parameter(Mandatory,ParameterSetName='HTML')][switch]$HTML,
        # Specifies the path to save the file at
        [Parameter(Mandatory,ParameterSetName='XML')]
        [Parameter(Mandatory,ParameterSetName='HTML')]
        [string]$Path,
        # Return the report as an array.
        [Parameter(ParameterSetName='Array')][switch]$Array,
        # Forces Gpresult to overwrite the file name specified.
        [Parameter(ParameterSetName='XML')]
        [Parameter(ParameterSetName='HTML')]
        [switch]$Force,
        # Displays RSoP summary data.
        [Parameter(ParameterSetName='Default')][switch]$RSoP,
        # Specifies that the super-verbose information should be displayed.
        [Parameter(ParameterSetName='Default')][switch]$SuperVerbose
    )
    
    begin {
        [string[]]$GPRparameters = @()
        if ($System) {
            $GPRparameters += ("/S",$System)
        }
        if ($Credentials) {
            $GPRparameters += ("/U",$Credentials.UserName,"/P","$($Credentials.Password | ConvertFrom-SecureString -AsPlainText)")
        }
        if ($Scope) {
            $GPRparameters += ("/SCOPE", $Scope)
        }
        if ($User) {
            $GPRparameters += ("/USER", $User)
        }
        if ($XML) {
            $GPRparameters += ("/X", $Path)
        } elseif ($HTML) {
            $GPRparameters += ("/H", $Path)
        } elseif ($Array) {
            $Path = "$(get-location)\GPResult.xml"
            $GPRparameters += ("/X", $Path, "/F")
        }
        if ($Force) {
            $GPRparameters += ("/F")
        }
        if ($RSoP) {
            $GPRparameters += ("/R")
        }
        if (($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) -and (-not($XML)) -and (-not($HTML)) -and (-not($Array))) {
            $GPRparameters += ("/V")
        }
        if ($SuperVerbose) {
            $GPRparameters += ("/Z")
        }
        Write-Verbose $($GPRparameters -join " ")
        if ($Array) {
            $null = gpresult.exe @GPRparameters
            [xml]$GPResult = Get-Content $Path
            Remove-Item $Path
            [GPObject[]]$GPOTable = @()
            [GPOSetting[]]$Return = @()
        } else {
            #$Return = gpresult.exe @GPRparameters
        }
    }
    
    process {
        if ($Array) {
            Write-Verbose "Bulding the table of GPOs"
            $GPOTable = Get-AppliedGPOs -GPResult $GPResult

            Write-Verbose $GPResult
            foreach ($data in $GPResult.Rsop.ChildNodes.ExtensionData) {
                foreach ($Node in $data.Extension.ChildNodes) {
                    if ($Node.LocalName -eq "Account") {
                        Write-Verbose "Adding an Account Object"
                        $GPEntry = [GPOSetting]::new()
                        $GPEntry.Policy = $Node.Name
                        $GPEntry.Precedence = $Node.Precedence.'#text'
                        if ($Node.SettingNumber) {
                            $GPEntry.Setting = $Node.SettingNumber
                        } elseif ($Node.SettingBoolean) {
                            $GPEntry.Setting = [System.Convert]::ToBoolean($Node.SettingBoolean)
                        } elseif ($Node.SettingString) {
                            $GPEntry.Setting = $Node.SettingString
                        } elseif ($Node.SettingStrings) {
                            $GPEntry.Setting = $Node.SettingStrings.Value
                        }
                        $GPEntry.Path = "Policies/Windows Settings/Security Settings/Account Policies/$($Node.Type) Policy"
                        [GPObject]$GPEntry.GPObject = $GPOTable | Where-Object {$_.Identifier -eq $Node.GPO.Identifier.'#text'}
                        $GPEntry.Node = $Node
                        $Return += $GPEntry
                    } elseif ($Node.LocalName -eq "AuditSetting") {
                        Write-Verbose "Adding an Audit Setting Object"
                        $GPEntry = [GPOSetting]::new()
                        $GPEntry.Policy = $Node.SubcategoryName
                        $GPEntry.Precedence = $Node.Precedence.'#text'
                        if ($Node.SettingValue = 1) {
                            $GPEntry.Setting = "Success"
                        } elseif ($Node.SettingValue = 2) {
                            $GPEntry.Setting = "Failure"
                        } elseif ($Node.SettingValue = 3) {
                            $GPEntry.Setting = "Success, Failure"
                        }
                        [GPObject]$GPEntry.GPObject = $GPOTable | Where-Object {$_.Identifier -eq $Node.GPO.Identifier.'#text'}
                        $GPEntry.Node = $Node
                        $GPEntry.Path = "Policies/Windows Settings/Security Settings/Advanced Audit Configuration"
                        $Return += $GPEntry
                    } elseif ($Node.LocalName -eq "UserRightsAssignment") {
                        Write-Verbose "Adding a User Rights Assignment Object"
                        $GPEntry = [GPOSetting]::new()
                        $GPEntry.Policy = $Node.Name
                        $GPEntry.Precedence = $Node.Precedence.'#text'
                        if ($node.Member.Count -gt 1) {
                            $Node.Member.Name.'#text' | ForEach-Object {$GPEntry.Setting += $_ +"; "}
                        } else {
                            $GPEntry.Setting = $Node.Member.Name.'#text'
                        }
                        $GPEntry.Path = "Policies/Windows Settings/Security Settings/Local Policies/User Rights Assignment"
                        [GPObject]$GPEntry.GPObject = $GPOTable | Where-Object {$_.Identifier -eq $Node.GPO.Identifier.'#text'}
                        $GPEntry.Node = $Node
                        $Return += $GPEntry
                    } elseif ($Node.LocalName -eq "SecurityOptions") {
                        Write-Verbose "Adding a Security Options Object"
                        $GPEntry = [GPOSetting]::new()
                        if ($Node.Display.Name) {
                            $GPEntry.Policy = $Node.Display.Name
                        } elseif ($Node.SystemAccessPolicyName) {
                            $GPEntry.Policy = $Node.SystemAccessPolicyName
                        }
                        $GPEntry.Precedence = $Node.Precedence.'#text'
                        if ($Node.Display.DisplayFields) {
                            $Node.Display.DisplayFields.Field | ForEach-Object {$GPEntry.Setting += $_.Name + ": " + $_.Value + "; "}
                        } elseif ($Node.Display.DisplayBoolean) {
                            $GPEntry.Setting = [System.Convert]::ToBoolean($Node.Display.DisplayBoolean)
                        } elseif ($Node.Display.DisplayNumber) {
                            $GPEntry.Setting = $Node.Display.DisplayNumber
                        } elseif ($Node.SettingString) {
                            $GPEntry.Setting = $Node.SettingString
                        } elseif ($Node.SettingStrings) {
                            $Node.SettingStrings.Value | ForEach-Object {$GPEntry.Setting += $_ + "; "}
                        } elseif ($Node.SettingNumber) {
                            $GPEntry.Setting = $Node.SettingNumber
                        }
                        $GPEntry.Path = "Policies/Windows Settings/Security Settings/Local Policies/Security Options"
                        [GPObject]$GPEntry.GPObject = $GPOTable | Where-Object {$_.Identifier -eq $Node.GPO.Identifier.'#text'}
                        $GPEntry.Node = $Node
                        $Return += $GPEntry
                    } elseif ($Node.LocalName -eq "SystemServices") {
                        Write-Verbose "Adding a System Services Object"
                        $GPEntry = [GPOSetting]::new()
                        $GPEntry.Policy = $Node.Name
                        $GPEntry.Precedence = $Node.Precedence.'#text'
                        $GPEntry.Setting = "Startup Mode: $($Node.StartupMode)"
                        [GPObject]$GPEntry.GPObject = $GPOTable | Where-Object {$_.Identifier -eq $Node.GPO.Identifier.'#text'}
                        $GPEntry.Path = "Policies/Windows Settings/Security Settings/System Services"
                        $GPEntry.Node = $Node
                        $Return += $GPEntry
                    } elseif (($Node.LocalName -eq "DomainProfile") -or ($Node.LocalName -eq "PublicProfile") -or ($Node.LocalName -eq "PrivateProfile")) {
                        Write-Verbose "Adding a Firewall Object"
                        foreach ($Profile in $Node.ChildNodes) {
                            $GPEntry = [GPOSetting]::new()
                            $GPEntry.Policy = $Profile.LocalName
                            $GPEntry.Precedence = $Profile.Precedence.'#text'
                            if ($Profile.Value -eq "true" -or $Profile.Value -eq "false") {
                                $GPEntry.Setting = [System.Convert]::ToBoolean($Profile.Value)
                            } else {
                                $GPEntry.Setting = $Profile.Value
                            }
                            [GPObject]$GPEntry.GPObject = $GPOTable | Where-Object {$_.Identifier -eq $Profile.GPO.Identifier.'#text'}
                            $GPEntry.Node = $Profile
                            $GPEntry.Path = "Policies/Windows Settings/Security Settings/Windows Firewall with Advanced Security/$($Node.LocalName) Settings"
                            $Return += $GPEntry
                        }
                    } elseif ($Node.LocalName -eq "Policy") {
                        Write-Verbose "Adding a PolicyObject"
                        $GPEntry = [GPOSetting]::new()
                        $GPEntry.Policy = $Node.Name
                        $GPEntry.Precedence = $Node.Precedence.'#text'
                        $GPEntry.Setting = $Node.State
                        [GPObject]$GPEntry.GPObject = $GPOTable | Where-Object {$_.Identifier -eq $Profile.GPO.Identifier.'#text'}
                        $GPEntry.Node = $Node
                        $GPEntry.Path = "Policies/Administrative Templates/$($Node.Category)"
                        $Return += $GPEntry
                    }
                }
            }
        }
    }
    
    end {
        return $Return
    }
}

function Get-AppliedGPOs {
    [CmdletBinding()]
    param (
        [Parameter()][xml]$GPResult
    )
    
    begin {
        if (-not($GPResult)) {
            $Path = "$(get-location)\GPResult.xml"
            gpresult.exe /x $Path /f | Out-Null
            [xml]$GPResult = Get-Content $Path
            Remove-Item $Path
        }
        [GPObject[]]$GPOTable = @()
    }
    
    process {
        $GPResult.Rsop.ComputerResults.GPO | ForEach-Object {
            if ($_.Link.AppliedOrder -ne 0) {
                $GPOTable += [GPObject]::new(@{
                    Name = $_.Name
                    Identifier = $_.Path.Identifier.'#text'
                    LinkLocation = $_.Link.SOMPath
                    ExtensionName = $_.ExtensionName
                    SecurityFilter = $_.SecurityFilter
                    VersionDirectory = $_.VersionDirectory
                    VersionSysvol = $_.VersionSysvol
                })
            }
        }

        $GPResult.Rsop.UserResults.GPO | ForEach-Object {
            if ($_.Link.AppliedOrder -ne 0) {
                $GPOTable += [GPObject]::new(@{
                    Name = $_.Name
                    Identifier = $_.Path.Identifier.'#text'
                    LinkLocation = $_.Link.SOMPath
                    ExtensionName = $_.ExtensionName
                    SecurityFilter = $_.SecurityFilter
                    VersionDirectory = $_.VersionDirectory
                    VersionSysvol = $_.VersionSysvol
                })
            }
        }
    }
    
    end {
        return $GPOTable
    }
}

class GPObject {
    [string]$Name
    [string]$Identifier
    [string]$LinkLocation
    [string[]]$ExtensionName
    [bool]$Enforced
    [string]$Disabled = "None"
    [string[]]$SecurityFilter
    [Int]$VersionDirectory
    [Int]$VersionSysvol
    [string]$WMIFilter

    # Default constructor
    GPObject() { $this.Init(@{}) }
    # Convenience constructor from hashtable
    GPObject([hashtable]$Properties) { $this.Init($Properties) }
    # Shared initializer method
    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}

class GPODetails {
    [string]$ComputerName
    [string]$Username
    [string]$Domain
    [string]$Site
    [string]$OrganizationalUnit
    [string[]]$ComputerSG
    [string[]]$UserSG
}

class GPOSetting {
    [string]$Policy
    [string]$Setting
    [GPObject]$GPObject
    [string]$Path
    [Int]$Precedence
    hidden $Node

    GPOSetting() { $this.Init(@{}) }
    # Convenience constructor from hashtable
    GPOSetting([hashtable]$Properties) { $this.Init($Properties) }
    # Shared initializer method
    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
    }
}
