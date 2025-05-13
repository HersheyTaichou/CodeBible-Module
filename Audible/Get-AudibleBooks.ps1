function Get-AudibleBooks {
        [CmdletBinding()]
        param (
        # Audible profile
        [Parameter()]
        [ValidateSet("Michael","Morgan")]
        [string]
        $AudibleProfile = "Michael"
        )

        begin {
                # Get the last run time
                $RuntimeFile = ".\$AudibleProfile.txt"
                if (Test-Path -Path $RuntimeFile) {
                        $StartDate = Get-Content $RuntimeFile | ConvertFrom-Json | Get-Date -UFormat "%Y-%m-%dT%H:%M:%SZ"
                }
                # Update the run time
                Get-Date -UFormat "%Y-%m-%dT%H:%M:%SZ" -AsUTC | ConvertTo-Json | Out-File $RuntimeFile -Force
        }

        process {
                # Get any new books
                audible -P $AudibleProfile download --ignore-podcasts --aaxc --chapter --pdf --cover --cover-size 1215 --start-date $StartDate --all

                # Decrypt the audiobooks
                audible -P $AudibleProfile decrypt -arfs

                # Remove encrypted books
                Get-ChildItem -Include "*.json","*.aaxc","*.voucher" -Recurse | Remove-Item

                # Organize the books and files
                $audiobooks = Get-ChildItem -Filter "*.m4b"
                foreach ($Book in $audiobooks) {
                        $Counter++
                        Write-Progress -Id 0 -Activity "Moving Books" -Status "$($Book.Name)" -PercentComplete (($Counter / $audiobooks.count) * 100)
                        Move-AudibleBook -Book $Book
                }
        }
}


function Move-AudibleBook {
        [CmdletBinding()]
        param (
                # Parameter help description
                [Parameter(Mandatory)]
                [System.IO.FileSystemInfo]
                $Book
        )
        process {
                $FolderName = "$(exiftool $Book -Artist -s -s -s)/$(exiftool $Book -Title -S -S -S)"
                if ((Test-Path $FolderName) -eq $false) {
                        mkdir -p $FolderName
                }
                Get-ChildItem -Filter "$($Book.Name.Split('-')[0])*" | Move-Item  -Destination "./$FolderName"
        }
}