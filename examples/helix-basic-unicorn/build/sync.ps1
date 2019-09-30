$ErrorActionPreference = 'Stop'

Import-Module "$PSScriptRoot\..\..\..\install-modules\helix.examples.psm1"
. $PSScriptRoot\settings.ps1

Write-Host "*******************************************************" -ForegroundColor Green
Write-Host " Build and Unicorn Sync $SitecoreSiteName" -ForegroundColor Green
Write-Host "*******************************************************" -ForegroundColor Green

Initialize-InstallAssets -PrepareAssetsConfiguration $PrepareAssetsConfiguration `
    -InstallTemp $InstallTemp `
    -ConfigPath $ConfigPath `
    -DownloadZip $DownloadZip `
    -AssetsRoot $AssetsRoot `
    -ConfigurationsZip $ConfigurationsZip `
    -ExampleConfigPath $ExampleConfigs

Push-Location $InstallTemp
$buildAndSyncParams = @{
    Path = $BuildAndSyncConfiguration
    SourceFolder = $SourceFolder
    BuildProject = $BuildProject
    PublishPath = $SitecoreSiteRoot
    SitecoreUrl = $SitecoreSiteUrl
    UnicornSecretConfig = $UnicornSecretConfig
}
try {
    Install-SitecoreConfiguration @buildAndSyncParams *>&1 | Tee-Object "$PSScriptRoot\log.sync.txt"
}
catch
{
    Write-Host "Build and sync failed" -ForegroundColor Red
    throw
}
finally {
    Pop-Location
}