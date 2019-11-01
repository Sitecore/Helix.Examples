$ExampleName = "Helix Basic - TDS"
$ExampleDescription = "This example demonstrates basic Helix solution architecture using TDS for serialization and builds."
$ExampleUrl = "https://sitecore.github.io/Helix.Examples/examples/helix-basic-company.html"
$SolutionPrefix = "helix-basic-tds"

# Solution build parameters
$SourceFolder = Resolve-Path "$PSScriptRoot\..\src"
$BuildProject = "$SourceFolder\..\BasicCompany.sln"

. $PSScriptRoot\..\..\..\settings.global.ps1 -ExampleBuildDirectory $PSScriptRoot

# Used to configure site host name patch
$HostNames = @{
    'basic-company' = $SitecoreSiteName
}