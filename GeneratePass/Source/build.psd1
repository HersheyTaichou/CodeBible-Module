@{
    Path = "GeneratePass.psd1"
    OutputDirectory = "..\bin\GeneratePass"
    Prefix = '.\_PrefixCode.ps1'
    SourceDirectories = 'Classes','Private','Public'
    PublicFilter = 'Public\*.ps1'
    VersionedOutputDirectory = $true
}
