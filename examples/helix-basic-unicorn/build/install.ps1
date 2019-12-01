$ErrorActionPreference = 'Stop'

Import-Module "$PSScriptRoot\..\..\..\install-modules\helix.examples.psm1"
. $PSScriptRoot\settings.ps1

Write-Host "*******************************************************" -ForegroundColor Green
Write-Host " Installing Sitecore $SitecoreVersion" -ForegroundColor Green
Write-Host " Sitecore: $SitecoreSiteName" -ForegroundColor Green
Write-Host " xConnect: $XConnectSiteName" -ForegroundColor Green
Write-Host " Identity: $IdentityServerSiteName" -ForegroundColor Green
Write-Host "*******************************************************" -ForegroundColor Green

Function Install-XP0SingleDeveloper {
    Push-Location $InstallTemp
    $singleDeveloperParams = @{
        Path = $InstallConfiguration
        LicenseFile = $LicenseFile
        SolrUrl = $SolrUrl
        SolrRoot = $SolrRoot
        SolrService = $SolrService
        SqlServer = $SqlServer
        SqlAdminUser = $SqlAdminUser
        SqlAdminPassword = $SqlAdminPassword
        SqlBuildVersion = $SqlBuildVersion
        SqlFriendlyVersion = $SqlFriendlyVersion
        SitecoreSiteName = $SitecoreSiteName
        Deploy_SourceFolder = $SourceFolder
        Deploy_BuildProject = $BuildProject
        Deploy_PublishPath = $SitecoreSiteRoot
        Deploy_SitecoreUrl = $SitecoreSiteUrl
        Deploy_UnicornSecretConfig = $UnicornSecretConfig
        Install_Prefix = $SolutionPrefix
        Install_XConnectCertificateName = $XConnectSiteName
        Install_IdentityServerCertificateName = $IdentityServerSiteName
        Install_IdentityServerSiteName = $IdentityServerSiteName
        Install_XConnectPackage = $XConnectPackage
        Install_SitecorePackage = $SitecorePackage
        Install_IdentityServerPackage = $IdentityServerPackage
        Install_XConnectSiteName = $XConnectSiteName
        Install_PasswordRecoveryUrl = $SitecoreSiteUrl
        Install_SitecoreIdentityAuthority = $IdentityServerUrl
        Install_XConnectCollectionService = $XConnectSiteUrl
        Install_ClientSecret = $IdentityClientSecret
        Install_AllowedCorsOrigins = $IdentityAllowedCorsOrigins
        Install_SitecoreAdminPassword = $SitecoreAdminPassword
        PostInstall_SitecoreSiteRoot = $SitecoreSiteRoot
        PostInstall_SitecoreHostNames = $HostNames
    }
    try {
        Install-SitecoreConfiguration @singleDeveloperParams *>&1 | Tee-Object "$PSScriptRoot\log.install.txt"
    }
    catch
    {
        Write-Host "Install and deploy failed" -ForegroundColor Red
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
    -ConfigurationsZip $ConfigurationsZip `
    -ExampleConfigPath $ExampleConfigs
Install-XP0SingleDeveloper