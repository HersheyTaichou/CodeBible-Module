# xkpasswd-Inspired Password Generator

This function creates random passwords using user-defined characteristics. It is inspired by the XKCD 936 comic and the password generator spawned from it, xkpasswd.net.

## DESCRIPTION

This function uses a dictionary array and the user's input to create a random memorable password. The module includes an example dictionary, which is imported when the module is loaded, and should be named $ExampleDictionary. It can be used to generate passwords for a variety of purposes and can also be used in combination with other functions to use a single-line password set command. This function can be used without parameters and will generate a password using 3 words between 4 and 8 characters each.

## Install in PowerShell

To install the module in PowerShell, so it does not have to be imported every time it is needed, download this entire folder and place it in Documents\PowerShell\Modules.

## PARAMETERS

### -Preset \<String\>

Parameter help description

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value |  |
| Accept pipeline input? | false |

### -WordCount \<Int32\>

This parameter is used to set the number of words in the password generated. The full range is between 1 and 24 words. Caution is advised at any count higher than 10

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 3 |
| Accept pipeline input? | false |

### -MinWordLength \<Int32\>

This parameter is used to set the minimum individual word length used in the password. The full range is between 1 and 24 characters. Selecting 24 will include all words up to 31 characters (it's not many). Its recommended value is 4. If none is specified, the default value of 4 will be used.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 4 |
| Accept pipeline input? | false |

### -MaxWordLength \<Int32\>

This parameter is used to set the maximum individual word length used in the password. The full range is between 1 and 24 characters. Selecting 24 will include all words up to 31 characters (it's not many). Its recommended value is 8. If none is specified, the default value of 8 will be used.

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

This is the default separator alphabet:

! @ $ % ^ & * - _ + = : | ~ ? / . ;

If an empty array is passed, it will default to a -

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

If using Adaptive padding

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

This parameter is used to set how many symbols are added to the end of the password. Set to 0 to not have any padding symbols.

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | 2 |
| Accept pipeline input? | false |

### -PaddingSymbols \<Char[]\>

This parameter is used to set an array of symbols to be used to pad the beginning and end of the password. Set to an empty value or $null to not have any padding, or set to just one character to force a particular character.

This is the default padding alphabet:

! @ $ % ^ & * - _ + = : | ~ ? / . ;

If an empty array is passed, it will default to a -

|  |  |
| ----- | ----- |
| Required? | false |
| Position? | named |
| Default value | @("!","@","$","%","^","&","*","-","_","+","=",":","\|","~","?","/",".",";") |
| Accept pipeline input? | false |

### -Dictionary \<String[]\>

This parameter is used to define an array of strings that will be used to select the words in the password. Custom dictionaries can be passed as a variable at run time or by updating the variable in `dictionary.ps1`. The default dictionary was created by combining two dictionary lists:

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
&&63&mohel&coopers&hibbin&65&&

Just running the command will generate a password with the default settings.
```

### EXAMPLE 2

```PowerShell
New-xkpasswd -WordCount 3 -MinimumWordLength 4 -MaximumWordLength 4 -Transformations RandomCapitalise -Separator @("-","+","=",".","*","_","|","~",",") -FrontPaddingDigits 0 -EndPaddingDigits 0 -FrontPaddingSymbols 1 -EndPaddingSymbols 1 -PaddingSymbols @("!","@","$","%","^","&","*","+","=",":","|","~","?") -Verbose
```

```text
VERBOSE: Dictionary contains 370222 words.
VERBOSE: 7197 potential words selected.
VERBOSE: Structure: [P][Word][S][Word][S][Word][P]
VERBOSE: Length: always 16 characters
!nies-haen-than!

This example will generate a password using the WEB16 settings from xkpasswd.net with verbosity enabled.
```
