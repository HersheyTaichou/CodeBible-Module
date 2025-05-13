function Test-AbsLibrary {
    [CmdletBinding()]
    param (
        # Creds to ABS
        [Parameter(Mandatory)]
        [pscredential]
        $Credential,
        # API Token
        [Parameter()]
        [securestring]
        $ApiToken
    )
    
    begin {
        $Profiles = "Michael","Morgan"
        $Properties = @{
            'Body' = @{
                'username' = $Credential.UserName
                'password' = $Credential.Password | ConvertFrom-SecureString -AsPlainText
            }
            'Uri' = "https://abs.oriontech.info/login" 
            'Method' = 'Post'
        }
        $ApiToken = ((Invoke-WebRequest @Properties).Content | ConvertFrom-Json).User.Token | ConvertTo-SecureString -AsPlainText -Force 
    }
    
    process {
        $Books = foreach ($P in $Profiles) {
            audible -P $P library export --output "$P.json" --format json
            $Item = Get-Content "$P.json" | ConvertFrom-Json | Select-Object *,Profile
            $Item | ForEach-Object {$_.Profile = $P}
            $item
            Remove-Item "$P.json"
        }
        $Headers = @{
            'Authorization' = "Bearer $($ApiToken | ConvertFrom-SecureString -AsPlainText)"
        }
        $Libraries = (Invoke-RestMethod -Uri "https://abs.oriontech.info/api/libraries" -Headers $Headers -Method Get).Libraries
        $LibraryItems = (Invoke-RestMethod -Uri "https://abs.oriontech.info/api/libraries/$($Libraries.Id)/items" -Headers $Headers -Method Get).results
        $return = Compare-Object -ReferenceObject $LibraryItems -DifferenceObject $Books
        $return = foreach ($B in $Books) {
            if ($B.asin -notin $LibraryItems.media.metadata.asin) {
                $B
            }
        }
    }
    
    end {
        return $return
    }
}