$FunctionsToDocument = @(
    # CISBenchmarkAudit
    'Test-CISBenchmark','Get-GPResult',
    # 1 Account Policies
    'Test-AccountPoliciesPasswordPolicy','Test-AccountPoliciesAccountLockoutPolicy','Test-CISBenchmarkAccountPolicies',
    # 1.1 Password Policy
    'Test-PasswordPolicyPasswordHistory','Test-PasswordPolicyMaxPasswordAge','Test-PasswordPolicyMinPasswordAge','Test-PasswordPolicyMinPasswordLength',
    'Test-PasswordPolicyComplexityEnabled','Test-PasswordPolicyRelaxMinimumPasswordLengthLimits','Test-PasswordPolicyReversibleEncryption',
    # 1.2 Account Lockout Policy
    'Test-AccountLockoutPolicyLockoutDuration','Test-AccountLockoutPolicyLockoutThreshold','Test-AccountLockoutPolicyAdminLockout','Test-AccountLockoutPolicyResetLockoutCount',
    # 2 Local Policies
    'Test-LocalPoliciesUserRightsAssignment','Test-LocalPoliciesSecurityOptions','Test-CISBenchmarkLocalPolicies',
    # 2.2 User Rights Assignment
    'Test-UserRightsAssignmentSeTrustedCredManAccessPrivilege','Test-UserRightsAssignmentSeNetworkLogonRight','Test-UserRightsAssignmentSeTcbPrivilege',
    'Test-UserRightsAssignmentSeMachineAccountPrivilege','Test-UserRightsAssignmentSeIncreaseQuotaPrivilege','Test-UserRightsAssignmentSeIncreaseQuotaPrivilege',
    'Test-UserRightsAssignmentSeInteractiveLogonRight','Test-UserRightsAssignmentSeRemoteInteractiveLogonRight','Test-UserRightsAssignmentSeBackupPrivilege',
    'Test-UserRightsAssignmentSeSystemTimePrivilege','Test-UserRightsAssignmentSeTimeZonePrivilege','Test-UserRightsAssignmentSeCreatePagefilePrivilege',
    'Test-UserRightsAssignmentSeCreateTokenPrivilege','Test-UserRightsAssignmentSeCreateGlobalPrivilege','Test-UserRightsAssignmentSeCreatePermanentPrivilege',
    'Test-UserRightsAssignmentSeCreateSymbolicLinkPrivilege','Test-UserRightsAssignmentSeDebugPrivilege','Test-UserRightsAssignmentSeDenyNetworkLogonRight',
    'Test-UserRightsAssignmentSeDenyBatchLogonRight','Test-UserRightsAssignmentSeDenyServiceLogonRight','Test-UserRightsAssignmentSeDenyInteractiveLogonRight',
    'Test-UserRightsAssignmentSeDenyRemoteInteractiveLogonRight','Test-UserRightsAssignmentSeEnableDelegationPrivilege','Test-UserRightsAssignmentSeRemoteShutdownPrivilege',
    'Test-UserRightsAssignmentSeAuditPrivilege','Test-UserRightsAssignmentSeImpersonatePrivilege','Test-UserRightsAssignmentSeIncreaseBasePriorityPrivilege',
    'Test-UserRightsAssignmentSeLoadDriverPrivilege','Test-UserRightsAssignmentSeLockMemoryPrivilege','Test-UserRightsAssignmentSeBatchLogonRight',
    'Test-UserRightsAssignmentSeSecurityPrivilege','Test-UserRightsAssignmentSeRelabelPrivilege','Test-UserRightsAssignmentSeSystemEnvironmentPrivilege',
    'Test-UserRightsAssignmentSeManageVolumePrivilege','Test-UserRightsAssignmentSeProfileSingleProcessPrivilege','Test-UserRightsAssignmentSeSystemProfilePrivilege',
    'Test-UserRightsAssignmentSeAssignPrimaryTokenPrivilege','Test-UserRightsAssignmentSeRestorePrivilege','Test-UserRightsAssignmentSeShutdownPrivilege',
    'Test-UserRightsAssignmentSeSyncAgentPrivilege','Test-UserRightsAssignmentSeTakeOwnershipPrivilege',
    # 2.3 Security Options
    'Test-SecurityOptionsAccounts','Test-SecurityOptionsAudit','Test-SecurityOptionsDevices','Test-SecurityOptionsDomainController','Test-SecurityOptionsDomainMember',
    'Test-SecurityOptionsInteractiveLogin','Test-SecurityOptionsMicrosoftNetworkClient','Test-SecurityOptionsMicrosoftNetworkServer','Test-SecurityOptionsNetworkAccess',
    'Test-SecurityOptionsNetworkSecurity','Test-SecurityOptionsShutdown','Test-SecurityOptionsSystemObjects','Test-SecurityOptionsUserAccountControl',
    # 2.3.1 Accounts
    'Test-AccountsNoConnectedUser','Test-AccountsEnableGuestAccount','Test-AccountsLimitBlankPasswordUse','Test-AccountsNewAdministratorName','Test-AccountsNewGuestName',
    # 2.3.2 Audit
    'Test-AuditSCENoApplyLegacyAuditPolicy','Test-AuditCrashOnAuditFail',
    # 2.3.4 Devices
    'Test-DevicesAllocateDASD','Test-DevicesAddPrinterDrivers',
    # 2.3.5 Domain Controller
    'Test-DomainControllerSubmitControl','Test-DomainControllerVulnerableChannelAllowList','Test-DomainControllerLdapEnforceChannelBinding',
    'Test-DomainControllerLDAPServerIntegrity','Test-DomainControllerRefusePasswordChange',
    # 2.3.6 Domain Member
    'Test-DomainMemberRequireSignOrSeal','Test-DomainMemberSealSecureChannel','Test-DomainMemberSignSecureChannel','Test-DomainMemberDisablePasswordChange',
    'Test-DomainMemberMaximumPasswordAge','Test-DomainMemberRequireStrongKey',
    # 2.3.7 Interactive Logon
    'Test-InteractiveLogonDisableCAD','Test-InteractiveLogonDontDisplayLastUserName','Test-InteractiveLogonInactivityTimeoutSecs',
    'Test-InteractiveLogonLegalNoticeText','Test-InteractiveLogonLegalNoticeCaption','Test-InteractiveLogonCachedLogonsCount','Test-InteractiveLogonPasswordExpiryWarning',
    'Test-InteractiveLogonForceUnlockLogon','Test-InteractiveLogonScRemoveOption',
    # 2.3.8 Microsoft Network Client
    'Test-MicrosoftNetworkClientRequireSecuritySignature','Test-MicrosoftNetworkClientEnableSecuritySignature','Test-MicrosoftNetworkClientEnablePlainTextPassword',
    # 2.3.9 Microsoft Network Server
    'Test-MicrosoftNetworkServerAutoDisconnect','Test-MicrosoftNetworkServerRequireSecuritySignature','Test-MicrosoftNetworkServerEnableSecuritySignature',
    'Test-MicrosoftNetworkServerEnableForcedLogOff','Test-MicrosoftNetworkServerSmbServerNameHardeningLevel',
    # 2.3.10 Network Access
    'Test-NetworkAccessLSAAnonymousNameLookup','Test-NetworkAccessRestrictAnonymousSAM','Test-NetworkAccessRestrictAnonymous','Test-NetworkAccessDisableDomainCreds',
    'Test-NetworkAccessEveryoneIncludesAnonymous','Test-NetworkAccessNullSessionPipes','Test-NetworkAccessAllowedExactPaths','Test-NetworkAccessAllowedPaths',
    'Test-NetworkAccessRestrictNullSessAccess','Test-NetworkAccessRestrictRemoteSAM','Test-NetworkAccessNullSessionShares','Test-NetworkAccessForceGuest',
    # 2.3.11 Network Security
    'Test-NetworkSecurityUseMachineId','Test-NetworkSecurityAllowNullSessionFallback','Test-NetworkSecurityAllowOnlineID','Test-NetworkSecuritySupportedEncryptionTypes',
    'Test-NetworkSecurityNoLMHash','Test-NetworkSecurityForceLogoffWhenHourExpire','Test-NetworkSecurityLmCompatibilityLevel','Test-NetworkSecurityLDAPClientIntegrity',
    'Test-NetworkSecurityNTLMMinClientSec','Test-NetworkSecurityNTLMMinServerSec',
    # 2.3.13 Shutdown
    'Test-ShutdownShutdownWithoutLogon',
    # 2.3.15 System Objects
    'Test-SystemObjectsObCaseInsensitive','Test-SystemObjectsProtectionMode',
    # 2.3.17 User Account Control
    'Test-UserAccountControlFilterAdministratorToken','Test-UserAccountControlConsentPromptBehaviorAdmin','Test-UserAccountControlConsentPromptBehaviorUser',
    'Test-UserAccountControlEnableInstallerDetection','Test-UserAccountControlEnableSecureUIAPaths','Test-UserAccountControlEnableLUA','Test-UserAccountControlPromptOnSecureDesktop',
    'Test-UserAccountControlEnableVirtualization',
    # 5 System Services
    'Test-SystemServicesSpooler','Test-CISBenchmarkSystemServices'
)

<#
.SYNOPSIS
Create a Markdown File from Get-Help

.DESCRIPTION
This will take a function's Get-Help output and convert it into a Markdown file, which can then be used for a GitHub wiki or other documentation options.

.PARAMETER FunctionsToDocument
An array of commands that you want Markdown files for

.EXAMPLE
New-MdDocumentation -FunctionsToDocument $@("Get-GPResult","Test-CISBenchmark")

.NOTES
General notes
#>
function New-MdDocumentation {
    [CmdletBinding()]
    param (
        # Functions to create a a MD file from Get-Help
        [Parameter(Mandatory)][array]$FunctionsToDocument
    )

    process {
        foreach ($Command in $FunctionsToDocument) {
            # Get the help info for the command
            $Help = Get-Help $Command
        
            # The title for the file is the name of the command
            $DocContents = "# " + $Help.Name + "`n`n"
            # Add each section from Get-Help
            $DocContents += "## SYNOPSIS`n`n" + $Help.Synopsis + "`n`n"
            $DocContents += "## DESCRIPTION`n`n" 
            $help.description | ForEach-Object {$DocContents += $_.Text + "`n`n"}
            # Skip the parameters if the command does not have any
            if ($Help.parameters) {
                $DocContents += "## PARAMETERS`n`n" 
                foreach ($Param in $Help.parameters.parameter)  {
                    $DocContents += "### -" + $Param.name + " \<" + $Param.parameterValue + "\>`n`n"
                    $DocContents += $Param.description[0].Text + "`n`n|  |  |`n| ----- | ----- |`n"
                    $DocContents += "| Required? | " + $Param.Required + " |`n"
                    $DocContents += "| Position? | " + $Param.Position + " |`n"
                    $DocContents += "| Default value | " + $Param.defaultValue + " |`n"
                    $DocContents += "| Accept pipeline input? | " + $Param.pipelineInput + " |`n`n"
                }
                
                
            }
            # Add each example
            $DocContents += "## EXAMPLE`n`n"
            $Count = 0
            foreach ($Example in $help.examples.Example) {
                $Count ++
                $DocContents += "### EXAMPLE " + $count + "`n`n"
                $DocContents += "``````PowerShell`n" + $Example.code + "`n```````n`n"
                $DocContents += "``````text`n"
                $Example.remarks | ForEach-Object {$DocContents += $_.Text}
                $DocContents += "`n```````n`n"
            }
            # Trim any extra trailing blank lines
            $DocContents = $DocContents.Trim()
            # Name the file after the command. 
            ## Github replaces the standard dash with a space in the title, I want to keep a dash.
            $FileName = ($Help.Name).replace("-","‐") + ".md"
            $DocContents | Out-File $FileName -Force
        }
    }
    
    end {}
}
