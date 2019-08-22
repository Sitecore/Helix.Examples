# Metadata for menuing
$ExampleName = "Helix Basic - Unicorn"
$ExampleDescription = "This example demonstrates basic Helix solution architecture using Unicorn for serialization and Helix Publishing Pipeline for builds."

# URL / Install Prefix
$SolutionPrefix = "helix-basic-unicorn"

# Solution build parameters
$BuildProject = "$PSScriptRoot\..\src\Deployment\Website\Website.csproj"
$UnicornSecretConfig = "$PSScriptRoot\..\src\Foundation\Serialization\website\App_Config\Include\Unicorn.SharedSecret.config"

. $PSScriptRoot\..\..\settings.global.ps1 -ExampleBuildDirectory $PSScriptRoot