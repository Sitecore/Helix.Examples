$ExampleName = "Helix Basic - TDS - Consolidated"
$ExampleDescription = "This example demonstrates basic Helix solution architecture, with a simplified Visual Studio structure, using TDS for serialization and builds."
$ExampleUrl = "https://sitecore.github.io/Helix.Examples/examples/helix-basic-company.html"
$SolutionPrefix = "helix-basic-tds-consolidated"

# Solution build parameters
$SourceFolder = Resolve-Path "$PSScriptRoot\..\src"
$BuildProject = "$SourceFolder\..\BasicCompany.sln"

. $PSScriptRoot\..\..\..\settings.global.ps1 -ExampleBuildDirectory $PSScriptRoot