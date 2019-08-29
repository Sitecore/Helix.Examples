$ExampleName = "Helix Basic - TDS"
$ExampleDescription = "**Not actually complete yet, but will install** ... This example demonstrates basic Helix solution architecture using TDS for serialization and builds."
$ExampleUrl = "https://github.com/Sitecore/Helix.Examples/helix-basic-tds"
$SolutionPrefix = "helix-basic-tds"

# Solution build parameters
$BuildProject = "$PSScriptRoot\..\src\Deployment\Website\Website.csproj"

. $PSScriptRoot\..\..\settings.global.ps1 -ExampleBuildDirectory $PSScriptRoot