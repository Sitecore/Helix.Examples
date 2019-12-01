# Metadata for menuing
$ExampleName = "Helix Basic - Unicorn"
$ExampleDescription = "This example demonstrates basic Helix solution architecture using Unicorn for serialization and Helix Publishing Pipeline for builds."
$ExampleUrl = "https://sitecore.github.io/Helix.Examples/examples/helix-basic-company.html"

# URL / Install Prefix
$SolutionPrefix = "helix-basic-unicorn"

# Solution build parameters
$SourceFolder = Resolve-Path "$PSScriptRoot\..\src"
$BuildProject = "$SourceFolder\Environment\Website\Website.csproj"
$UnicornSecretConfig = "$SourceFolder\Foundation\Serialization\website\App_Config\Include\Unicorn.SharedSecret.config"

. $PSScriptRoot\..\..\..\settings.global.ps1 -ExampleBuildDirectory $PSScriptRoot

# Used to configure site host name patch
$HostNames = @{
    'basic-company' = $SitecoreSiteName
}