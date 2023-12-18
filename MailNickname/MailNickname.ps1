<#
.SYNOPSIS
Set the mail nickname.

.DESCRIPTION
Updates the mail nickname for one account or for all the members of an OU to match the user's sAMAccountName.

.PARAMETER SearchBase
The OU in Distinguished Name format. This is the default.

.PARAMETER sAMAccountName
The sAMAccountName for one user, when only updating a single user.

.EXAMPLE
Set-MailNickname -SearchBase OU=Users,OU=Main Office,DC=domain,DC=local

.EXAMPLE
Set-MailNickname -sAMAccountName JMartin

.NOTES
General notes
#>
function Set-MailNickname {
    [CmdletBinding()]
    param (
        # Specifies an Active Directory path to search under.
        [Parameter(ParameterSetName='All')]
        [String]
        $SearchBase = (Get-ADDomain).DistinguishedName,
        [Parameter(ParameterSetName='Single')]
        [String]
        $sAMAccountName
    )
    process {
        if ($sAMAccountName) {
            try {
                $ValidatedSAN = Get-ADObject -Filter "sAMAccountName -eq $sAMAccountName" -Properties *
                $Nickname = $ValidatedSAN.sAMAccountName
                Set-ADObject -Identity $ValidatedSAN -replace @{mailnickname=$Nickname}
                $Message = $User.DisplayName + " MailNickname updated"
                Write-Verbose $Message
            }
            catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
                $Message = $sAMAccountName + " was not found in Active Directory`n`n" + $_
                $RecommendedAction = "Confirm the sAMAccountName is correct and try again."
                Write-Error -Message $Message -Category InvalidData -RecommendedAction $RecommendedAction
            }
            catch [Microsoft.ActiveDirectory.Management.Commands.SetADObject] {
                $Message = "Unable to set the Mail Nickname attribute`n`n" + $_
                $RecommendedAction = "Confirm Active Directory includes the MailNickname attribute"
                Write-Error -Message $Message -RecommendedAction $RecommendedAction -Category InvalidOperation
            }
            catch {
                $Message = "An unrecoverable error occured`n`n" + $_
                Write-Error $Message
            }
        }
        else {
            try {
                $ADUsers = Get-ADUser -Filter * -SearchBase $SearchBase -Properties *
                foreach ($User in $ADUsers) {
                    if (-not($User.MailNickname)) {
                        $Nickname = $user.sAMAccountName
                        Set-ADObject -Identity $User -replace @{mailnickname=$Nickname}
                        $Message = $User.DisplayName + " MailNickname updated"
                        Write-Verbose $Message
                    } else {
                        $Message = $User.DisplayName + " MailNickname already set"
                        Write-Verbose $Message
                    }
                }
            }
            catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
                $Message = "Unable to gather a list of users from $Searchbase`n`n" + $_
                $RecommendedAction = "Confirm the Search Base is correct and try again."
                Write-Error -Message $Message -Category InvalidData -RecommendedAction $RecommendedAction
            }
            catch [Microsoft.ActiveDirectory.Management.Commands.SetADObject] {
                $Message = "Unable to set the Mail Nickname attribute for " + $User.sAMAccountName + "`n`n" + $_
                $RecommendedAction = "Confirm Active Directory includes the MailNickname attribute"
                Write-Error -Message $Message -RecommendedAction $RecommendedAction -Category InvalidOperation
            }
            catch {
                $Message = "An unrecoverable error occured while processing "+ $User.sAMAccountName + "`n`n" + $_
                Write-Error $Message
            }
        }
    }
}
