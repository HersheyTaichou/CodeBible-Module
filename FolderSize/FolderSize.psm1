class FolderSize {
    [string]$Name # The name of the folder
    [string]$Size # The readable size of the items in the folder
    [string]$FullSize # The readable size of the items in the folder, including all subfolders and files
    [int64]$Length # The size of the items in the folder
    [int64]$FullLength # The size of the items in the folder, including all subfolders and files
    [string]$FullName # The whole path of the folder
}

<#
.SYNOPSIS
Gets the folder size for a directory including subfolders.

.DESCRIPTION
Calculates the total file size for the contents of each folder underneath the provided starting point, outputs a list of folder name / file size pairs. Default behavior is to list sizes under current working directory.

.PARAMETER Path
This should be a string to the folder you want to check the size of. 

Defaults to the current directory.

.PARAMETER ExcludePath
This will exclude a folder and any folders under it.

.PARAMETER RExclude
This will exclude anything that matches a RegEx string.

.PARAMETER LargestFolders
Parameter description

.PARAMETER TopFolders
Parameter description

.EXAMPLE
Get-FolderSize -Path "C:\Users\Username\Pictures"

Name                    Length FullLength FullName
----                    ------ ---------- --------

Pictures             144202638 2682500262 C:\Users\Username\Pictures
Background            42915644   42915644 C:\Users\Username\Pictures\Background
Camera              2489078746 2495381980 C:\Users\Username\Pictures\Camera
2023                   6303234    6303234 C:\Users\Username\Pictures\Camera\2023

.EXAMPLE 
Get-FolderSize -Path C:\Users\Username -ExcludePath "C:\Users\Username\AppData"

.NOTES
Add \\?\ for longer paths support
- Identify top n largest files / folders within search scope
- Top foldes with largest content within the folder (no subfolders)
- Exclude path switch
- include path
- Regex support for include/exclude (separate from main)

#>
function Get-FolderSize {
    [CmdletBinding()]
    param (
        # Path to the folder to check, default is the current location
        [Parameter()][String]$Path = (Get-Item -Path $(Get-Location)),
        # Act as if this directory doesn't exist
        [Parameter()][String]$ExcludePath,
        # Remove anything that matches this regex string
        [Parameter()][regex]$RExclude,
        # Identify top n largest folders
        [Parameter()][int]$LargestFolders,
        # Identify top n largest folders (excluding subfolders)
        [Parameter()][int]$TopFolders
    )
    
    begin {
        if (-not(Test-Path $Path)) {
            $Message = "Cannot find path '$Path' because it does not exist."
            $RecommendedAction = "Confirm the folder path, then try again"
            Write-Error -Message $Message -Category ObjectNotFound -RecommendedAction $RecommendedAction -TargetObject $Path
            Return
        }
        $DirsToCheck = @(Get-Item $Path)
        $FolderItems = Get-ChildItem -Path $Path -Recurse
        if ($ExcludePath) {
            # If given a path with a trailing backslash, remove it
            $ExcludePath = $ExcludePath.Trim("\")
            $Message = "Excluding directory: " + $ExcludePath
            Write-Verbose $Message
            # If excluding a directory, remove everything that does starts with that directory
            $FolderItems = $FolderItems | where-object {$_.FullName -notlike "$ExcludePath*"}
        }
        # If excluding something with a regex string, remove everything that matches that string
        if ($RExclude) {
            $Message = "Excluding RegEx string: " + $RExclude
            Write-Verbose $Message
            $FolderItems = $FolderItems | where-object {$_.FullName -notmatch $RExclude}
        }
        # Separate out the directories from the items
        $DirsToCheck += $FolderItems | Where-Object {($_.PSIsContainer -eq $true)}
        $Message = "Reviewing " + $DirsToCheck.Count + " Total folders"
        Write-Verbose $Message
        $Return = @()
    }
    
    process {
        # Get the total length for all the files in each directory
        $Counter = 0
        foreach ($Dir in $DirsToCheck) {
            $Counter++
            Write-Progress -Activity 'Processing directories' -CurrentOperation $Dir.FullName -PercentComplete (($Counter / $DirsToCheck.count) * 100)
            $FolderLength = 0
            $FolderCLength = 0
            $ResolvedTarget = $dir.ResolvedTarget
            # Get the total length for all the files in just this directory
            $FolderItems | Where-Object {($_.PSIsContainer -eq $false) -and ($_.DirectoryName -eq $ResolvedTarget)} | ForEach-Object {$FolderLength += $_.Length}
            # Get the total length for all the files in and under this directory
            $FolderItems | Where-Object {($_.PSIsContainer -eq $false) -and ($_.DirectoryName -like "$ResolvedTarget*")} | ForEach-Object {$FolderCLength += $_.Length}
            # Convert the folder length to readable lengths
            $FolderSize = Get-ReadableLength -Length $FolderLength
            $FolderCSize = Get-ReadableLength -Length $FolderCLength
            # Skip folders that do not have any items in them
            if ($FolderLength -ge 1) {
                $Result = [FolderSize]::new()
                $Result.Name = $Dir.Name
                $Result.Size = $FolderSize
                $Result.FullSize = $FolderCSize
                $Result.Length = $FolderLength
                $Result.FullLength = $FolderCLength
                $Result.FullName = $Dir.Fullname
                $Return += $Result
            }
        }
    }
    
    end {
        if ($LargestFolders) {
            $LargestFolders --
            return ($Return | Sort-Object FullLength)[0..$LargestFolders]
        } elseif ($TopFolders) {
            $TopFolders --
            return ($Return | Sort-Object Length)[0..$TopFolders]
        } else {
            return $Return | Sort-Object FullName
        }
    }
}

<#
.SYNOPSIS
Converts a File Length to a Readable String

.DESCRIPTION
This function will take an int and divide it by 1024 until it is under that, round it to two decimal places, then append the matching extension and return it

.PARAMETER Length
An int that you want converted to a readable string

.EXAMPLE
Get-ReadableLength -Length 2048

2 KB

.NOTES
This is an internal-only function for the Get-FolderSize Function
#>
function Get-ReadableLength {
    [CmdletBinding()]
    param (
        # the Int Length to convert to a readable string
        [Parameter()]
        [float]
        $Length
    )
    
    begin {
        # Array of file size extensions
        $byte = @("B","KB","MB","GB","TB","PB","EB","ZB","YB")
    }
    
    process {
        $Ext = 0
        # Convert the length to the smallest whole number under 1024
        while (($Length -gt 1024) -and ($ext -le 8)) {
            $Length = [math]::Round(($Length / 1024),2)
            $Ext += 1
        }

        # Append the extension that matches how many times we divided by 1024
        $ReadLength = [string]$Length + " " + $byte[$ext]
    }
    
    end {
        return $ReadLength
    }
}

Export-ModuleMember -Function "Get-FolderSize"
