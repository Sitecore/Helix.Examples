$ErrorActionPreference = 'Stop'

Import-Module "..\\..\\..\\install-modules\\helix.examples.psm1"
. $PSScriptRoot\settings.ps1

Write-Host "*******************************************************" -ForegroundColor Green
Write-Host " Validing settings and installing prerequisites for $SitecoreVersion" -ForegroundColor Green
Write-Host "*******************************************************" -ForegroundColor Green

Function Expand-Install-Assets {
    Push-Location $ConfigPath
    $expandAssetsParams = @{
        Path = $ExpandAssetsConfiguration
        DownloadZip = $DownloadZip
        AssetsPath = $AssetsRoot
        ConfigurationsZip = $ConfigurationsZip
    }
    try {
        Install-SitecoreConfiguration @expandAssetsParams
    }
    catch
    {
        Write-Host "Expanding install assets failed" -ForegroundColor Red
        throw
    }
    finally {
        Pop-Location
    }
}

Function Install-Prerequisites {
    #Run Prepare Config
    Push-Location $ConfigPath
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
Expand-Install-Assets

# Workaround for SIF issue -- can't include Prerequisites.json otherwise
((Get-Content $ConfigPath\Prerequisites.json -Raw) -replace '\+\+','PlusPlus') | Set-Content $ConfigPath\Prerequisites.json

Install-Prerequisites