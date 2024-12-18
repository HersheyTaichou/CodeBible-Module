<#
.SYNOPSIS
This function will return a random number.

.DESCRIPTION
This function takes two numbers and returns a random number between those two numbers. It defaults to the minimum and maximum possible value for an integer, which is a range of 4,294,967,295

.PARAMETER Min
The minimum number to consider. Defaults to the minimum value for an integer (-2147483648)

.PARAMETER Max
The maximum number to consider. Defaults to the maximum value for an integer (2147483647)

.EXAMPLE
Get-RandomInt -Minimum 0 -Maximum 100

81

This example generates a random number between 0 and 100

.EXAMPLE
Get-RandomInt -Minimum 0

1461304439

This example generates a random number between 0 and [Int]::MaxValue

.EXAMPLE
Get-RandomInt

-1728936647

This example generates a random number between [Int]::minValue and [Int]::MaxValue

.NOTES
General notes
#>
function Get-RandomInt {
    [CmdletBinding()]
    param (
        # The lowest number to include. Defaults to the lowest possible number
        [Parameter()][int]$Minimum = [Int]::MinValue,
        
        # the highest number to include
        [Parameter()][int]$Maximum = [Int]::MaxValue
    )
    
    process {
        # Check to make sure minimum is less then maximum, then get a random number
        if ($Minimum -lt $Maximum) {
            $Return = [System.Security.Cryptography.RandomNumberGenerator]::GetInt32($Minimum,$Maximum)
        } else {
            Write-Warning 'Minimum length must be less than Maximum length'
            return -1
        }
    }
    
    end {
        return $Return
    }
}
