# xkpasswd-Inspired Password Generator

This function creates random passwords using user-defined characteristics. It is inspired by the XKCD 936 comic and the password generator spawned from it, xkpasswd.net.

## DESCRIPTION

This function uses a dictionary array and the user's input to create a random memorable password. The module includes an example dictionary, which is imported when the module is loaded, and should be named $ExampleDictionary. It can be used to generate passwords for a variety of purposes and can also be used in combination with other functions to use a single-line password set command. This function can be used without parameters and will generate a password using 3 words between 4 and 8 characters each.

## Install in PowerShell

To install the module in PowerShell, so it does not have to be imported every time it is needed, download this entire folder and place it in Documents\PowerShell\Modules.

## PARAMETERS

### -Preset \<String\>

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
  - \$PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
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
  - \$PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
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
  - \$PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
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
  - \$PaddingSymbols = @("!","@","$","%","^","&","*","+","=",":","|","~","?")
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

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value |  |
| Accept pipeline input? | false |

### -WordCount \<Int32\>

This parameter is used to set the number of words in the password that is generated.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 3 |
| Accept pipeline input? | false |

### -MinWordLength \<Int32\>

This parameter is used to set the minimum individual word length used in the password. The full range is between 1 and 24 characters. Selecting 24 will include any words over 24 characters. Its recommended value is 4. If none is specified, the default value of 4 will be used.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 4 |
| Accept pipeline input? | false |

### -MaxWordLength \<Int32\>

This parameter is used to set the maximum individual word length used in the password. The full range is between 1 and 24 characters. Selecting 24 will include all words over 24 characters. Its recommended value is 8. If none is specified, the default value of 8 will be used.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 8 |
| Accept pipeline input? | false |

### -Transformations \<String\>

This parameter is used to select how the words should be transformed. It will only accept the following options:

- None = Apply no changes to the words, use them exactly as listed in the dictionary array
- alternatingWORDcase = Capitalize every even word
- CapitaliseFirstLetter = Capitalize the first letter of each word
- cAPITALIZEeVERYlETTERbUTfIRST = Capitalize every letter except for the first letter in each word
- lowercase = Force all the words to lowercase
- UPPERCASE = Force all the words to uppercase
- RandomCapitalise = Randomly capitalize each word or not

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | AlternatingWordCase |
| Accept pipeline input? | false |

### -Separator \<Char[]\>

This parameter is used to set an array of symbols to be used as a separator between sections and words. Set to an empty value or $null to not have a separator, or set to just one character to force a particular character.

If an empty array is passed, it will default to a dash (-)

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | @("!","@","$","%","^","&","*","-","_","+","=",":","\|","~","?","/",".",";") |
| Accept pipeline input? | false |

### -FrontPaddingDigits \<Int32\>

This parameter is used to set how many digits are added to the beginning of the password. Set to 0 to not have any padding digits.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 2 |
| Accept pipeline input? | false |

### -EndPaddingDigits \<Int32\>

This parameter is used to set how many digits are added to the end of the password. Set to 0 to not have any padding digits.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 2 |
| Accept pipeline input? | false |

### -AdaptivePaddingLength \<Int32\>

This parameter is used to enforce a maximum length for the password, for instance, to generate a password that is always 64 characters long. It will add the padding symbol to the end of the password until it reaches this length.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 0 |
| Accept pipeline input? | false |

### -FrontPaddingSymbols \<Int32\>

This parameter is used to set how many symbols are added to the beginning of the password. Set to 0 to not have any padding symbols.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 2 |
| Accept pipeline input? | false |

### -EndPaddingSymbols \<Int32\>

This parameter is used to set how many symbols are added to the end of the password. Set to 0 to not have any padding symbols. AdaptingPaddingLength will override this to add symbols to the end.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 2 |
| Accept pipeline input? | false |

### -PaddingSymbols \<Char[]\>

This parameter is used to set an array of symbols to be used to pad the beginning and end of the password. If this is set to an empty value or $null, it will default to a dash (-). You can set it to just one character to force a particular character.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | @("!","@","$","%","^","&","*","-","_","+","=",":","\|","~","?","/",".",";") |
| Accept pipeline input? | false |

### -Dictionary \<String[]\>

Custom dictionaries can be passed as a variable at run time or by updating the variable in `dictionary.ps1`. The default dictionary was created by combining two dictionary lists:

- <https://github.com/garrett-wood/Public/tree/master/XKCD%20Password%20Generatror>
- <https://github.com/bartificer/xkpasswd-js>

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | $ExampleDictionary |
| Accept pipeline input? | false |

### -Count \<Int32\>

Specifies the number of passwords to generate

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 3 |
| Accept pipeline input? | false |

## EXAMPLE

### EXAMPLE 1

```PowerShell
New-xkpasswd
```

```text
@@25/unrainy/DORMMICE/tengere/17@@
++36$misfate$ALAUND$chapatis$14++
@@08_winemay_DUOTONES_yigh_81@@

Just running the command will generate three passwords with the default settings.
```

### EXAMPLE 2

```PowerShell
New-xkpasswd -WordCount 3 -MinWordLength 4 -MaxWordLength 4 -Transformations RandomCapitalise -Separator @("-","+","=",".","*","_","|","~",",") -FrontPaddingDigits 0 -EndPaddingDigits 0 -FrontPaddingSymbols 1 -EndPaddingSymbols 1 -PaddingSymbols @("!","@","$","%","^","&","*","+","=",":","|","~","?") -Verbose
```

```text
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
```

### EXAMPLE 3

```PowerShell
New-xkpasswd -Preset Web16
```

```text
|cycl.MAPO.ower|
^neon|lour|GOOL^
&RYEN_kelt_clod&

This example will generate a password using the Web16 preset
```

## Dictionary.ps1

This file contains two arrays. The first array is a list of words to be used as the dictionary when generating passwords. The second array is a count of words, based on the number of letters in each word. The following script can be used to generate the array. It should then be included in the dictionary file.

```powershell
$Run = 1
$DictCounts = do {
    $Count = ($ExampleDictionary | where-object {($_.Length -eq $Run)}).Count
    $Count
    $Run++
} while ($count -gt 0)

```

This script should be run and the saved array updated every time the dictionary array is changed.
