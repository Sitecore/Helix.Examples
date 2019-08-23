$ErrorActionPreference = 'Stop'

Import-Module "$PSScriptRoot\install-modules\helix.examples.psm1"
. $PSScriptRoot\settings.global.ps1

Write-Host "*******************************************************" -ForegroundColor Green
Write-Host " Validing settings and installing prerequisites for $SitecoreVersion" -ForegroundColor Green
Write-Host "*******************************************************" -ForegroundColor Green

Function Install-Prerequisites {
    #Run Prepare Config
    Push-Location $InstallTemp
    $prepareParams = @{
        Path = $PrepareConfiguration
        PreInstall_SolrUrl = $SolrUrl
        PreInstall_SolrRoot = $SolrRoot
        PreInstall_SolrService = $SolrService
        PreInstall_SqlServer = $SqlServer
        PreInstall_SqlAdminUser = $SqlAdminUser
        PreInstall_SqlAdminPassword = $SqlAdminPassword
        PreInstall_SqlBuildVersion = $SqlBuildVersion
        PreInstall_SqlFriendlyVersion = $SqlFriendlyVersion
    }
    try {
        Install-SitecoreConfiguration @prepareParams *>&1 | Tee-Object "$PSScriptRoot\log.prepare.txt"
    }
    catch
    {
        Write-Host "Install preparation failed" -ForegroundColor Red
        throw
    }
    finally {
        Pop-Location
    }
}

Import-SitecoreInstallFramework -InstallerVersion $InstallerVersion
Initialize-InstallAssets -PrepareAssetsConfiguration $PrepareAssetsConfiguration `
    -InstallTemp $InstallTemp `
    -ConfigPath $ConfigPath `
    -DownloadZip $DownloadZip `
    -AssetsRoot $AssetsRoot `
    -ConfigurationsZip $ConfigurationsZip

# Workaround for SIF issue -- can't include Prerequisites.json otherwise
((Get-Content $InstallTemp\Prerequisites.json -Raw) -replace '\+\+','PlusPlus') | Set-Content $InstallTemp\Prerequisites.json

Install-Prerequisites