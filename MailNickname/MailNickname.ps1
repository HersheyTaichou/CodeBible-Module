function Set-MailNickname {
    [CmdletBinding()]
    param (
        # Specifies an Active Directory path to search under.
        [Parameter()]
        [String]
        $SearchBase = (Get-ADDomain).DistinguishedName
    )
    
    begin {
        $ADUsers = Get-ADUser -Filter * -SearchBase $SearchBase -Properties *
    }
    
    process {
        foreach ($User in $ADUsers) {
            if (-not($User.MailNickname)) {
                $Nickname = $user.SamAccountName
                Set-ADObject -Identity $User -replace @{mailnickname=$Nickname} -whatif
                $Message = $User.DisplayName + " MailNickname updated"
                Write-Host $Message -ForegroundColor Green
            } else {
                $Message = $User.DisplayName + " MailNickname already set"
                Write-Host $Message
            }
        }
    }
    
    end {
        
    }
}