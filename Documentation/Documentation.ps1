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
        [Parameter(Mandatory)][string[]]$FunctionsToDocument
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
