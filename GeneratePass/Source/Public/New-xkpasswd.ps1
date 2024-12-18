<#
.SYNOPSIS
This function creates random passwords using user-defined characteristics. It is inspired by the XKCD 936 comic and the password generator spawned from it, xkpasswd.net.

.DESCRIPTION
This function uses a dictionary array and the user's input to create a random memorable password. The module includes an example dictionary, which is imported when the module is loaded, and should be named $ExampleDictionary. It can be used to generate passwords for a variety of purposes and can also be used in combination with other functions to use a single-line password set command. This function can be used without parameters and will generate a password using 3 words between 4 and 8 characters each.

.PARAMETER Preset
This parameter is used to select one of the following presets:

- AppleID
  - $WordCount = 3
  - $MinWordLength = 5
  - $MaxWordLength = 7
  - $Transformations = "RandomCapitalise"
  - $Separator = @("-",":",".",",")
  - $FrontPaddingDigits = 2
  - $EndPaddingDigits = 2
  - $FrontPaddingSymbols = 1
  - $EndPaddingSymbols = 1
  - $PaddingSymbols = @("!","?","@","&")
- NTLM
  - $WordCount = 2
  - $MinWordLength = 5
  - $MaxWordLength = 5
  - $Transformations = "cAPITALIZEeVERYlETTERbUTfIRST"
  - $Separator = @("-","+","=",".","*","_","|","~",",")
  - $FrontPaddingDigits = 1
  - $EndPaddingDigits = 0
  - $FrontPaddingSymbols = 0
  - $EndPaddingSymbols = 1
  - $PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
- SecurityQ
  - $WordCount = 6
  - $MinWordLength = 4
  - $MaxWordLength = 8
  - $Transformations = "None"
  - $Separator = @(" ")
  - $FrontPaddingDigits = 0
  - $EndPaddingDigits = 0
  - $FrontPaddingSymbols = 0
  - $EndPaddingSymbols = 1
  - $PaddingSymbols = @(".","!","?")
- Web16
  - $WordCount = 3
  - $MinWordLength = 4
  - $MaxWordLength = 4
  - $Transformations = "RandomCapitalise"
  - $Separator = @("-","+","=",".","*","_","|","~",",")
  - $FrontPaddingDigits = 0
  - $EndPaddingDigits = 0
  - $FrontPaddingSymbols = 1
  - $EndPaddingSymbols = 1
  - $PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
- Web32
  - $WordCount = 4
  - $MinWordLength = 4
  - $MaxWordLength = 5
  - $Transformations = "alternatingWORDcase"
  - $Separator = @("-","+","=",".","*","_","|","~",",")
  - $FrontPaddingDigits = 2
  - $EndPaddingDigits = 2
  - $FrontPaddingSymbols = 1
  - $EndPaddingSymbols = 1
  - $PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
- WiFi
  - $WordCount = 6
  - $MinWordLength = 4
  - $MaxWordLength = 8
  - $Transformations = "RandomCapitalise"
  - $Separator = @("-","+","=",".","*","_","|","~",",")
  - $FrontPaddingDigits = 4
  - $EndPaddingDigits = 4
  - $FrontPaddingSymbols = 0
  - $AdaptivePaddingLength = 63
  - $PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
- XKCD
  - $WordCount = 4
  - $MinWordLength = 4
  - $MaxWordLength = 8
  - $Transformations = "RandomCapitalise"
  - $Separator = @("-")
  - $FrontPaddingDigits = 0
  - $EndPaddingDigits = 0
  - $FrontPaddingSymbols = 0
  - $EndPaddingSymbols = 0

.PARAMETER WordCount
This parameter is used to set the number of words in the password that is generated.

.PARAMETER MinWordLength
This parameter is used to set the minimum individual word length used in the password. The full range is between 1 and 24 characters. Selecting 24 will include any words over 24 characters. Its recommended value is 4. If none is specified, the default value of 4 will be used.

.PARAMETER MaxWordLength
This parameter is used to set the maximum individual word length used in the password. The full range is between 1 and 24 characters. Selecting 24 will include all words over 24 characters. Its recommended value is 8. If none is specified, the default value of 8 will be used.

.PARAMETER Transformations
This parameter is used to select how the words should be transformed. It will only accept the following options:

- None = Apply no changes to the words, use them exactly as listed in the dictionary array
- alternatingWORDcase = Capitalize every even word
- CapitaliseFirstLetter = Capitalize the first letter of each word
- cAPITALIZEeVERYlETTERbUTfIRST = Capitalize every letter except for the first letter in each word
- lowercase = Force all the words to lowercase
- UPPERCASE = Force all the words to uppercase
- RandomCapitalise = Randomly capitalize each word or not

.PARAMETER Separator
This parameter is used to set an array of symbols to be used as a separator between sections and words. Set to an empty value or $null to not have a separator, or set to just one character to force a particular character.

If an empty array is passed, it will default to a dash (-)

.PARAMETER FrontPaddingDigits
This parameter is used to set how many digits are added to the beginning of the password. Set to 0 to not have any padding digits.

.PARAMETER EndPaddingDigits
This parameter is used to set how many digits are added to the end of the password. Set to 0 to not have any padding digits.

.PARAMETER AdaptivePaddingLength
This parameter is used to enforce a maximum length for the password, for instance to generate a password that is always 64 characters long. It will add the padding symbol to the end of the password until it reaches this length.

.PARAMETER FrontPaddingSymbols
This parameter is used to set how many symbols are added to the beginning of the password. Set to 0 to not have any padding symbols.

.PARAMETER EndPaddingSymbols
This parameter is used to set how many symbols are added to the end of the password. Set to 0 to not have any padding symbols. AdaptingPaddingLength will override this to add symbols to the end.

.PARAMETER PaddingSymbols
This parameter is used to set an array of symbols to be used to pad the beginning and end of the password. If this is set to an empty value or $null, it will default to a dash (-). You can set to just one character to force a particular character.

.PARAMETER Dictionary
Custom dictionaries can be passed as a variable at run time or by updating the variable in `dictionary.ps1`. The default dictionary was created by combining two dictionary lists:

- <https://github.com/garrett-wood/Public/tree/master/XKCD%20Password%20Generatror>
- <https://github.com/bartificer/xkpasswd-js>

.PARAMETER Count
Specifies the number of passwords to generate

.EXAMPLE
New-xkpasswd

@@25/unrainy/DORMMICE/tengere/17@@
++36$misfate$ALAUND$chapatis$14++
@@08_winemay_DUOTONES_yigh_81@@

Just running the command will generate three passwords with the default settings.

.EXAMPLE
New-xkpasswd -WordCount 3 -MinWordLength 4 -MaxWordLength 4 -Transformations RandomCapitalise -Separator @("-","+","=",".","*","_","|","~",",") -FrontPaddingDigits 0 -EndPaddingDigits 0 -FrontPaddingSymbols 1 -EndPaddingSymbols 1 -PaddingSymbols @("!","@","$","%","^","&","*","+","=",":","|","~","?") -Verbose

VERBOSE: SETTINGS:
        WORDS: 3 words between 4 and 4 letters.
        TRANSFORMATIONS: EVERY word randomly CAPITALISED or NOT
        SEPARATOR: a character randomly chosen from the set: [-] [+] [=] [.] [*] [_] [|] [~] [,]
        PADDING DIGITS: -none-
        PADDING SYMBOLS: 1 symbol will be added to the front and back of the password.The symbol will be randomly chosen from the set: [!] [@] [$] [%] [^] [&] [*] [+] [=] [:] [|] [~] [?]
VERBOSE: Dictionary contains 370222 words, which was filtered to 7197 potential words.
VERBOSE: SUMMARY
        STRUCTURE: [P][Word][S][Word][S][Word][P]
        LENGTH: always 16 characters
        ENTROPY: exactly 102.55 bits blind & 48.31 bits with full knowledge (Suggest keeping blind entropy above 78 bits and seen above 52 bits)
+ODUM=DIAN=PULE+
|YUTU|TADS|brot|
+MOWT|DOPA|ARAR+

This example will generate a custom password with verbosity enabled.

.EXAMPLE
New-xkpasswd -Preset Web16

|cycl.MAPO.ower|
^neon|lour|GOOL^
&RYEN_kelt_clod&

This example will generate a password using the Web16 preset

.NOTES
RELATED LINKS
XKCD Comic 936: https://xkcd.com/936/
XKPasswd:       https://xkpasswd.net/
Original:       https://github.com/garrett-wood/Public/blob/master/XKCD%20Password%20Generatror/New-SecurePassword.ps1

CHANGELOG
- VERSION 1.0 - LAST MODIFIED: 2019.02.16
  - Original version from https://www.reddit.com/r/PowerShell/comments/arccbg/update_xkcd_password_generator/
- VERSION 2.0
  - Expands the script to have more flexibility and more closely match the version found on XKPASSWD, but implimented entirely in PowerShell
  - Adds the presets from XKPASSWD with matching settings
  - Allows generating multiple passwords
  - Adds entropy details for the password generated
- Version 2.1
  - Changes how words are selected from the array to speed up password generation
#>
function New-xkpasswd {
    [cmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([string])]
    
    Param( 
        # Parameter help description
        [Parameter(ParameterSetName='Preset')]
        [ValidateSet("AppleID","NTLM","SecurityQ","Web16","Web32","WiFi","XKCD")]
        [string]$Preset,

        # The number of words to include
        [Parameter(ParameterSetName='Default')]
        [int]$WordCount = 3, 

        # The minimum length of words to consider
        [Parameter(ParameterSetName='Default')]
        [ValidateRange(1,24)]
        [int]$MinWordLength = 4,

        # the maximum length of words to consider
        [Parameter(ParameterSetName='Default')]
        [ValidateRange(1,24)]
        [int]$MaxWordLength = 8,

        # How to transform the words
        [Parameter(ParameterSetName='Default')]
        [ValidateSet("None","alternatingWORDcase","CapitaliseFirstLetter","cAPITALIZEeVERYlETTERbUTfIRST","lowercase","UPPERCASE","RandomCapitalise")]
        [String]$Transformations = "AlternatingWordCase",

        # Separator character randomly chosen from this set
        [Parameter(ParameterSetName='Default')]
        [char[]]$Separator = @("!","@","$","%","^","&","*","-","_","+","=",":","|","~","?","/",".",";"),

        # Padding digits at the front of the password
        [Parameter(ParameterSetName='Default')]
        [int]$FrontPaddingDigits = 2, 

        # Padding digits at the end of the password
        [Parameter(ParameterSetName='Default')]
        [int]$EndPaddingDigits = 2, 

        # If using Adaptive padding
        [Parameter(ParameterSetName='Default')]
        [int]$AdaptivePaddingLength, 

        # Padding symbols at the front of the password
        [Parameter(ParameterSetName='Default')]
        [int]$FrontPaddingSymbols = 2, 

        # Padding symbols at the end of the password
        [Parameter(ParameterSetName='Default')]
        [int]$EndPaddingSymbols = 2, 

        # Padding character randomly chosen from this set
        [Parameter(ParameterSetName='Default')]
        [char[]]$PaddingSymbols = @("!","@","$","%","^","&","*","-","_","+","=",":","|","~","?","/",".",";"),

        # An array of strings to use as the dictionary
        [string[]]$Dictionary = $ExampleDictionary,

        # Number of passwords to generate
        [Parameter()]
        [int]$Count = 3
    )
    
    begin {
        # DEFINE VARIABLES
        [String]$PWStructure = ""
        [Int]$MinLength = 0
        [Int]$MaxLength = 0
        [string[]]$PasswordArray = $null

        # If a preset was selected, set all the details for that preset
        #"AppleID","NTLM","SecurityQ","Web16","Web32","WiFi","XKCD"
        if ($Preset) {
            Write-Verbose "PRESETS: $Preset"
        }
        
        If ($Preset -eq "AppleID") {
            $WordCount = 3
            $MinWordLength = 5
            $MaxWordLength = 7
            $Transformations = "RandomCapitalise"
            $Separator = @("-",":",".",",")
            $FrontPaddingDigits = 2
            $EndPaddingDigits = 2
            $FrontPaddingSymbols = 1
            $EndPaddingSymbols = 1
            $PaddingSymbols = @("!","?","@","&")
        } elseif ($Preset -eq "NTLM") {
            $WordCount = 2
            $MinWordLength = 5
            $MaxWordLength = 5
            $Transformations = "cAPITALIZEeVERYlETTERbUTfIRST"
            $Separator = @("-","+","=",".","*","_","|","~",",")
            $FrontPaddingDigits = 1
            $EndPaddingDigits = 0
            $FrontPaddingSymbols = 0
            $EndPaddingSymbols = 1
            $PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
        } elseif ($Preset -eq "SecurityQ") {
            $WordCount = 6
            $MinWordLength = 4
            $MaxWordLength = 8
            $Transformations = "None"
            $Separator = @(" ")
            $FrontPaddingDigits = 0
            $EndPaddingDigits = 0
            $FrontPaddingSymbols = 0
            $EndPaddingSymbols = 1
            $PaddingSymbols = @(".","!","?")
        } elseif ($Preset -eq "Web16") {
            $WordCount = 3
            $MinWordLength = 4
            $MaxWordLength = 4
            $Transformations = "RandomCapitalise"
            $Separator = @("-","+","=",".","*","_","|","~",",")
            $FrontPaddingDigits = 0
            $EndPaddingDigits = 0
            $FrontPaddingSymbols = 1
            $EndPaddingSymbols = 1
            $PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
        } elseif ($Preset -eq "Web32") {
            $WordCount = 4
            $MinWordLength = 4
            $MaxWordLength = 5
            $Transformations = "alternatingWORDcase"
            $Separator = @("-","+","=",".","*","_","|","~",",")
            $FrontPaddingDigits = 2
            $EndPaddingDigits = 2
            $FrontPaddingSymbols = 1
            $EndPaddingSymbols = 1
            $PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
        } elseif ($Preset -eq "WiFi") {
            $WordCount = 6
            $MinWordLength = 4
            $MaxWordLength = 8
            $Transformations = "RandomCapitalise"
            $Separator = @("-","+","=",".","*","_","|","~",",")
            $FrontPaddingDigits = 4
            $EndPaddingDigits = 4
            $FrontPaddingSymbols = 0
            $AdaptivePaddingLength = 63
            $PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
        } elseif ($Preset -eq "XKCD") {
            $WordCount = 4
            $MinWordLength = 4
            $MaxWordLength = 8
            $Transformations = "RandomCapitalise"
            $Separator = @("-")
            $FrontPaddingDigits = 0
            $EndPaddingDigits = 0
            $FrontPaddingSymbols = 0
            $EndPaddingSymbols = 0
        }
        
        # Print out the current settings in a readable format
        $Settings = "SETTINGS:"
        $Settings += "`n`t"
        $Settings += "WORDS: $($WordCount) words between $($MinWordLength) and $($MaxWordLength) letters."
        $Settings += "`n`t"
        $EntropyCase = 1
        $Alphabet = 52
        if ($Transformations -eq "None"){
            $settings += "TRANSFORMATIONS: -none-"
            $Alphabet = 26
        } elseif ($Transformations -eq "alternatingWORDcase"){
            $settings += "TRANSFORMATIONS: alternating WORD case"
            $EntropyCase = 2
        } elseif ($Transformations -eq "CapitaliseFirstLetter"){
            $settings += "TRANSFORMATIONS: Capitalize First Letter"
        } elseif ($Transformations -eq "cAPITALIZEeVERYlETTERbUTfIRST"){
            $settings += "TRANSFORMATIONS: cAPITALIZE eVERY lETTER eXCEPT tHE fIRST"
        } elseif ($Transformations -eq "lowercase"){
            $settings += "TRANSFORMATIONS: lower case"
            $Alphabet = 26
        } elseif ($Transformations -eq "UPPERCASE"){
            $settings += "TRANSFORMATIONS: UPPER CASE"
            $Alphabet = 26
        } elseif ($Transformations -eq "RandomCapitalise"){
            $settings += "TRANSFORMATIONS: EVERY word randomly CAPITALISED or NOT"
            $EntropyCase = 2
        }
        $Settings += "`n`t"
        if ($Separator.count -eq 0) {
            # Don't add Separator
        } elseif ($Separator.count -eq 1) {
            $Settings += "SEPARATOR: The character [$($Separator)]"
            $Settings += "`n`t"
        } else {
            $Settings += "SEPARATOR: a character randomly chosen from the set: [$($Separator -join "] [")]"
            $Settings += "`n`t"
        }
        if (($FrontPaddingDigits -eq 0) -and ($EndPaddingDigits -eq 0)) {
            $Settings += "PADDING DIGITS: -none-"
        } elseif (($FrontPaddingDigits -eq 1) -and ($EndPaddingDigits -eq 0)) {
            $Settings += "PADDING DIGITS: $FrontPaddingDigits digit before and none after the words."
        } elseif (($FrontPaddingDigits -gt 1) -and ($EndPaddingDigits -eq 0)) {
            $Settings += "PADDING DIGITS: $FrontPaddingDigits digits before and none after the words."
        } elseif (($FrontPaddingDigits -eq 0) -and ($EndPaddingDigits -ge 1)) {
            $Settings += "PADDING DIGITS: No digits before and $EndPaddingDigits after the words."
        } elseif (($FrontPaddingDigits -eq 1) -and ($EndPaddingDigits -eq $FrontPaddingDigits)) {
            $Settings += "PADDING DIGITS: $FrontPaddingDigits digit before and after the words."
        } elseif (($FrontPaddingDigits -gt 1) -and ($EndPaddingDigits -eq $FrontPaddingDigits)) {
            $Settings += "PADDING DIGITS: $FrontPaddingDigits digits before and after the words."
        } elseif (($FrontPaddingDigits -eq 1) -and ($EndPaddingDigits -ne $FrontPaddingDigits) -and ($EndPaddingDigits -gt 1)) {
            $Settings += "PADDING DIGITS: $FrontPaddingDigits digit before and $EndPaddingDigits after the words."
        } elseif (($FrontPaddingDigits -gt 1) -and ($EndPaddingDigits -ne $FrontPaddingDigits) -and ($EndPaddingDigits -gt 1)) {
            $Settings += "PADDING DIGITS: $FrontPaddingDigits digits before and $EndPaddingDigits after the words."
        }
        $Settings += "`n`t"
        if (-not($AdaptivePaddingLength)){
                if (($FrontPaddingSymbols -eq 0) -and ($EndPaddingSymbols -eq 0)) {
                $Settings += "PADDING SYMBOLS: -none-"
            } elseif (($FrontPaddingSymbols -eq 1) -and ($EndPaddingSymbols -eq 0)) {
                $Settings += "PADDING SYMBOLS: $FrontPaddingSymbols symbol will be added to the front of the password, and none to the back."
            } elseif (($FrontPaddingSymbols -gt 1) -and ($EndPaddingSymbols -eq 0)) {
                $Settings += "PADDING SYMBOLS: $FrontPaddingSymbols symbols will be added to the front of the password, and none to the back."
            } elseif (($FrontPaddingSymbols -eq 0) -and ($EndPaddingSymbols -ge 1)) {
                $Settings += "PADDING SYMBOLS: No symbols will be added to the front of the password, and $EndPaddingSymbols to the back."
            } elseif (($FrontPaddingSymbols -eq 1) -and ($EndPaddingSymbols -eq $FrontPaddingSymbols)) {
                $Settings += "PADDING SYMBOLS: $FrontPaddingSymbols symbol will be added to the front and back of the password."
            } elseif (($FrontPaddingSymbols -gt 1) -and ($EndPaddingSymbols -eq $FrontPaddingSymbols)) {
                $Settings += "PADDING SYMBOLS: $FrontPaddingSymbols symbols will be added to the front and back of the password."
            } elseif (($FrontPaddingSymbols -eq 1) -and ($EndPaddingSymbols -ne $FrontPaddingSymbols) -and ($EndPaddingSymbols -gt 1)) {
                $Settings += "PADDING SYMBOLS: $FrontPaddingSymbols symbol will be added to the front of the password, and $EndPaddingSymbols to the back."
            } elseif (($FrontPaddingSymbols -gt 1) -and ($EndPaddingSymbols -ne $FrontPaddingSymbols) -and ($EndPaddingSymbols -gt 1)) {
                $Settings += "PADDING SYMBOLS: $FrontPaddingSymbols symbols will be added to the front of the password, and $EndPaddingSymbols to the back."
            }
        } else {
            $Settings += "PADDING SYMBOLS: The password will be padded to a length of $AdaptivePaddingLength characters with a symbol."
        }
        if (($FrontPaddingSymbols -eq 0) -and ($EndPaddingSymbols -eq 0)) {
        } elseif (($FrontPaddingSymbols -ge 1) -or ($EndPaddingSymbols -ge 1) -or $AdaptivePaddingLength) {
            if ($PaddingSymbols.Count -eq 1) {
                $Settings += "The symbol [$($PaddingSymbols)] will be used"
            } else {
                $Settings += "The symbol will be randomly chosen from the set: [$($PaddingSymbols -join "] [")]"
            }
        }
        Write-Verbose $Settings
    }
    
    process {
        <#
        (Verbose) Display password structure and length
        1. Select padding symbols
        2. Select padding numbers
        3. Select separator
        4. Select random words
          filter dictionary to just words in word length
          get random number in array length
          Use random number to get array entry
        5. Select padding numbers
        6. Select padding symbols
        #>

        <# Filter the dictionary down to just the words that fit within the selected length
        if ($MinWordLength -le $MaxWordLength) {
            if (($MinWordLength -lt 24) -and $MaxWordLength -lt 24){
                [string[]]$FilteredDictionary = $Dictionary | Where-Object {($_.Length -ge $MinWordLength) -and ($_.Length -le $MaxWordLength)}
            } elseif (($MinWordLength -eq 24) -or ($MaxWordLength -eq 24)) {
                [string[]]$FilteredDictionary = $Dictionary | Where-Object {$_.Length -ge $MinWordLength}
            }
        } else {
            Write-Warning "Minimum word length is greater than maximum word length."
            return
        }#>

        $FilteredCount = ($dictCounts[$($MinWordLength-1)..$($MaxWordLength-1)] | Measure-Object -Sum).Sum
        Write-Verbose "Dictionary contains $($Dictionary.Count) words, which was filtered to $FilteredCount potential words."
        

        # Display password structure and length
        if ($FrontPaddingSymbols) {
            For( $C=1; $C -le $FrontPaddingSymbols; $C++ ) {
                $PWStructure += '[P]'
                $MinLength++
            }
            $AlphabetSymbols = $true
        }
        if ($FrontPaddingDigits) {
            For( $C=1; $C -le $FrontPaddingDigits; $C++ ) {
                $PWStructure += '[D]'
                $MinLength++
            }
            $AlphabetDigits = $true
        }
        if ($Separator -and $FrontPaddingDigits) {
            $PWStructure += '[S]'
            $MinLength++
            $AlphabetSymbols = $true
        }
        For( $C=1; $C -le $WordCount; $C++ ) {
            $PWStructure += '[Word]'
            $MinLength += $MinWordLength
            $MaxLength += $MaxWordLength - $MinWordLength
            if ($Separator -and $C -lt $WordCount) {
                $PWStructure += '[S]'
                $MinLength++
                $AlphabetSymbols = $true
            }
        }
        if ($Separator -and ($EndPaddingDigits)) {
            $PWStructure += '[S]'
            $MinLength++
            $AlphabetSymbols = $true
        }
        if ($EndPaddingDigits) {
            For( $C=1; $C -le $EndPaddingDigits; $C++ ) {
                $PWStructure += '[D]'
                $MinLength++
            }
            $AlphabetDigits = $true
        }
        if ($EndPaddingSymbols -and (-not($AdaptivePaddingLength))) {
            For( $C=1; $C -le $EndPaddingSymbols; $C++ ) {
                $PWStructure += '[P]'
                $MinLength++
                $AlphabetSymbols = $true
            }
        }
        if (($AdaptivePaddingLength) -and ($MinLength -lt $AdaptivePaddingLength)) {
            $PWStructure += '[P]...[P]'
            $MinLength = 63
            $MaxLength = 0
            $AlphabetSymbols = $true
        }
        $MaxLength += $MinLength
        $VerboseMessage = "SUMMARY:`n`tSTRUCTURE: $($PWStructure)`n`t"
        $VerboseMessage += "LENGTH: "
        if ($MinLength -eq $MaxLength) {
            $VerboseMessage += "always $($MinLength) characters"
        } else {
            $VerboseMessage += "between $($MinLength) and $($MaxLength) characters"
        }
        if ($AlphabetDigits) {
            $Alphabet += 10
        }
        if ($AlphabetSymbols) {
            $Alphabet += 33
        }
        $EntropyNKMin = [math]::log2([math]::pow($Alphabet,$MinLength))
        $EntropyNKMax = [math]::log2([math]::pow($Alphabet,$MaxLength))
        # Find the known entropy

        # Find the number of possible words, when the dictionary is known, for a brute force attack.
        ## Number of words in the filtered dictionary times 2 if we randomize the case
        $EntropyWords = $Dictionary.Count * $EntropyCase

        $EntropySeen = [math]::pow($EntropyWords,$WordCount)

        if ($Separator) {
            $EntropySeen = $EntropySeen * $Separator.Count
        }
        if ($FrontPaddingSymbols -or $EndPaddingSymbols) {
            $EntropySeen = $EntropySeen * $PaddingSymbols.Count
        }

        if ($FrontPaddingDigits -or $EndPaddingDigits) {
            $EntropySeen = $EntropySeen * [math]::pow(10,$FrontPaddingDigits + $EndPaddingDigits)
        }

        $EntropySeen = [math]::log2($EntropySeen)

        $VerboseMessage += "`n`tENTROPY: "
        if ($EntropyNKMin -eq $EntropyNKMax) {
            $VerboseMessage += "exactly $([math]::Round($EntropyNKMin,2)) bits blind"
        } else {
            $VerboseMessage += "between $([math]::Round($EntropyNKMin,2)) bits & $([math]::Round($EntropyNKMax,2)) bits blind"
        }
        $VerboseMessage += " & $([math]::Round($EntropySeen,2)) bits with full knowledge (Suggest keeping blind entropy above 78 bits and seen above 52 bits)"
        Write-Verbose $VerboseMessage

        for ($i = 0; $i -lt $count; $i++) {
            [string]$SecurePassword = $null
            # Select a random padding symbol from the provided array
            if ($PaddingSymbols.Count -gt 1) {
                $PadSymbol = $PaddingSymbols[(Get-RandomInt -Minimum 0 -Maximum ($PaddingSymbols.Count - 1))]
            } elseif ($PaddingSymbols.Count -eq 1) {
                $PadSymbol = $PaddingSymbols[0]
            } else {
                $PadSymbol = "-"
            }

            # Select a random separator character from the provided array
            if ($Separator.Count -gt 1) {
                $SeparatorChar = $Separator[(Get-RandomInt -Minimum 0 -Maximum ($Separator.Count - 1))]
            } elseif ($Separator.Count -eq 1) {
                $SeparatorChar = $Separator[0]
            } else {
                $SeparatorChar = "-"
            }

            # Add padding symbols to the beginning of the password, if included
            if ($FrontPaddingSymbols) {
                For( $C=1; $C -le $FrontPaddingSymbols; $C++ ) {
                    $SecurePassword += $PadSymbol
                }
            }
            # Add padding digits to the beginning of the password, if included
            if ($FrontPaddingDigits) {
                For( $C=1; $C -le $FrontPaddingDigits; $C++ ) {
                    $SecurePassword += Get-RandomInt -Minimum 0 -Maximum 9
                }
            }

            # Place a separator between the above and the first word, if included
            if ($Separator -and $FrontPaddingDigits) {
                $SecurePassword += $SeparatorChar
            }

            # Add the words to the password, using the selected transformation, separated by the separator characters, if applicable
            For( $C=1; $C -le $WordCount; $C++ ) {
                #$CurrentWord = $FilteredDictionary[(Get-RandomInt -Minimum 0 -Maximum ($FilteredDictionary.Count - 1))]

                do {
                    $Index = Get-RandomInt -Minimum 0 -Maximum ($Dictionary.Count - 1)
                    $CurrentWord = $Dictionary[$Index]
                } until (
                    ($CurrentWord.Length -ge $MinWordLength) -and ($CurrentWord.Length -le $MaxWordLength)
                )

                If ($Transformations -eq "None") {
                    $SecurePassword += $CurrentWord
                } elseif ($Transformations -eq "alternatingWORDcase") {
                    if ([bool]!($C % 2)) {
                        $SecurePassword += $CurrentWord.ToUpper()
                    } else {
                        $SecurePassword += $CurrentWord.ToLower()
                    }
                } elseif ($Transformations -eq "CapitaliseFirstLetter") {
                    $SecurePassword += $CurrentWord.Substring(0,1).ToUpper() + $CurrentWord.Substring(1).ToLower()
                } elseif ($Transformations -eq "cAPITALIZEeVERYlETTERbUTfIRST") {
                    $SecurePassword += $CurrentWord.Substring(0,1).ToLower() + $CurrentWord.Substring(1).ToUpper()
                } elseif ($Transformations -eq "lowercase") {
                    $SecurePassword += $CurrentWord.ToLower()
                } elseif ($Transformations -eq "UPPERCASE") {
                    $SecurePassword += $CurrentWord.ToUpper()
                } elseif ($Transformations -eq "RandomCapitalise") {
                    if ((Get-RandomInt -Minimum 0) % 2) {
                        $SecurePassword += $CurrentWord.ToUpper()
                    } else {
                        $SecurePassword += $CurrentWord.ToLower()
                    }
                }
                if ($Separator -and $C -lt $WordCount) {
                    $SecurePassword += $SeparatorChar
                }
            }

            # Place a separator between the words and the end padding digits, if applicable
            if ($Separator -and $EndPaddingDigits) {
                $SecurePassword += $SeparatorChar
            }

            # Add padding digits to the end of the password, if included
            if ($EndPaddingDigits) {
                For( $C=1; $C -le $EndPaddingDigits; $C++ ) {
                    $SecurePassword += Get-RandomInt -Minimum 0 -Maximum 9
                }
            }

            # Add padding symbols to the end  of the password, if included
            if ($EndPaddingSymbols -and (-not($AdaptivePaddingLength))) {
                For( $C=1; $C -le $EndPaddingSymbols; $C++ ) {
                    $SecurePassword += $PadSymbol
                }
            }
            # If adaptive padding was selected, add the padding symbol to the end until the final length is reached
            if (($AdaptivePaddingLength) -and ($SecurePassword.Length -lt $AdaptivePaddingLength)) {
                $SymbolsToAdd = $AdaptivePaddingLength - $SecurePassword.Length
                For( $C=1; $C -le $SymbolsToAdd; $C++ ) {
                    $SecurePassword += $PadSymbol
                }
            }
            $PasswordArray += $SecurePassword
        }
    }

    end {
        # Return the generated password
        if ($Count -eq 1) {
            return $SecurePassword
        } else {
            return $PasswordArray
        }
    }
}
