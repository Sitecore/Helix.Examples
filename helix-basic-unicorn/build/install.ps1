$ErrorActionPreference = 'Stop'

Import-Module "$PSScriptRoot\..\\..\\install-modules\\helix.examples.psm1"
. $PSScriptRoot\settings.ps1

Write-Host "*******************************************************" -ForegroundColor Green
Write-Host " Installing Sitecore $SitecoreVersion" -ForegroundColor Green
Write-Host " Sitecore: $SitecoreSiteName" -ForegroundColor Green
Write-Host " xConnect: $XConnectSiteName" -ForegroundColor Green
Write-Host " Identity: $IdentityServerSiteName" -ForegroundColor Green
Write-Host "*******************************************************" -ForegroundColor Green

Function Install-Prerequisites {
    #Run Prerequisites Config
    Push-Location $ConfigPath
    try {
        Install-SitecoreConfiguration -Path $PrerequisitiesConfiguration *>&1 | Tee-Object "$PSScriptRoot\log.prerequisites.txt"
    }
    finally {
        Pop-Location
    }
}

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

Function Install-XP0SingleDeveloper {
    Push-Location $ConfigPath
    $singleDeveloperParams = @{
        Path = $InstallConfiguration
        SolrUrl = $SolrUrl
        SolrRoot = $SolrRoot
        SolrService = $SolrService
        SqlServer = $SqlServer
        SqlAdminUser = $SqlAdminUser
        SqlAdminPassword = $SqlAdminPassword
        SqlBuildVersion = $SqlBuildVersion
        SqlFriendlyVersion = $SqlFriendlyVersion
        SitecoreSiteName = $SitecoreSiteName
        Deploy_BuildProject = $BuildProject
        Deploy_PublishPath = $SitecoreSiteRoot
        Deploy_SitecoreUrl = $SitecoreSiteUrl
        Deploy_UnicornSecretConfig = $UnicornSecretConfig
        Install_Prefix = $SolutionPrefix
        Install_XConnectCertificateName = $XConnectSiteName
        Install_IdentityServerCertificateName = $IdentityServerSiteName
        Install_IdentityServerSiteName = $IdentityServerSiteName
        Install_LicenseFile = $LicenseFile
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
Expand-Install-Assets
Install-XP0SingleDeveloper