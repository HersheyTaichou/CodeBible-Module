@{
    Path = "ExoMailbox.psd1"
    OutputDirectory = "..\bin\ExoMailbox"
    Prefix = '.\_PrefixCode.ps1'
    SourceDirectories = 'Classes','Private','Public'
    PublicFilter = 'Public\*.ps1'
    VersionedOutputDirectory = $true
}
