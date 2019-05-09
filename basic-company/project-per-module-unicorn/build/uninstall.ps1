$ErrorActionPreference = "Stop"

Import-Module ..\\..\\..\\install-modules\\helix.examples.psm1
. $PSScriptRoot\settings.ps1

Write-Host "*******************************************************" -ForegroundColor Green
Write-Host " Uninstalling Sitecore $SitecoreVersion" -ForegroundColor Green
Write-Host " Sitecore: $SitecoreSiteName" -ForegroundColor Green
Write-Host " xConnect: $XConnectSiteName" -ForegroundColor Green
Write-Host "*******************************************************" -ForegroundColor Green

Function Uninstall-XP0SingleDeveloper {
    Push-Location $ConfigPath
    $uninstallParams = @{
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
        Install_SitecoreSitename = $SitecoreSiteName
        Install_PasswordRecoveryUrl = $SitecoreSiteUrl
        Install_SitecoreIdentityAuthority = $IdentityServerUrl
        Install_XConnectCollectionService = $XConnectSiteUrl
        Install_ClientSecret = $IdentityClientSecret
        Install_AllowedCorsOrigins = $IdentityAllowedCorsOrigins
        Install_SitecoreAdminPassword = $SitecoreAdminPassword
    }
    try {
        Uninstall-SitecoreConfiguration @uninstallParams *>&1 | Tee-Object "$PSScriptRoot\log.uninstall.txt"
    }
    catch
    {
        Write-Host "Uninstall failed" -ForegroundColor Red
        throw
    }
    finally {
        Pop-Location
    }
}

Import-SitecoreInstallFramework -InstallerVersion $InstallerVersion
Uninstall-XP0SingleDeveloper