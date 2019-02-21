$ErrorActionPreference = "Stop"
. $PSScriptRoot\settings.ps1
if (Test-Path $PSScriptRoot\settings.user.ps1) {
    . $PSScriptRoot\settings.user.ps1
}

Write-Host "*******************************************************" -ForegroundColor Green
Write-Host " Uninstalling Sitecore $SitecoreVersion" -ForegroundColor Green
Write-Host " Sitecore: $SitecoreSiteName" -ForegroundColor Green
Write-Host " xConnect: $XConnectSiteName" -ForegroundColor Green
Write-Host "*******************************************************" -ForegroundColor Green

Push-Location $ConfigPath
$uninstallParams = @{
    Path = $SingleDeveloperConfiguration
    Deploy_BuildProject = $BuildProject
    Deploy_SitecoreUrl = $SitecoreSiteUrl
    Deploy_UnicornSecretConfig = $UnicornSecretConfig
    Install_SqlServer = $SqlServer
    Install_SqlAdminUser = $SqlAdminUser
    Install_SqlAdminPassword = $SqlAdminPassword
    Install_SolrUrl = $SolrUrl
    Install_SolrRoot = $SolrRoot
    Install_SolrService = $SolrService
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
    Uninstall-SitecoreConfiguration @uninstallParams *>&1 | Tee-Object "$PSScriptRoot\uninstall.log"
}
catch
{
    write-host "Uninstall failed" -ForegroundColor Red
    throw
}
finally {
    Pop-Location
}

# Remove App Pool membership 
try 
{
    Remove-LocalGroupMember "Performance Log Users" "IIS AppPool\$SitecoreSiteName"
    Write-Host "Removed IIS AppPool\$SitecoreSiteName from Performance Log Users" -ForegroundColor Green
}
catch 
{
    Write-Host "Could not find IIS AppPool\$SitecoreSiteName in Performance Log Users" -ForegroundColor Yellow
}
try 
{
    Remove-LocalGroupMember "Performance Monitor Users" "IIS AppPool\$SitecoreSiteName"
    Write-Host "Removed IIS AppPool\$SitecoreSiteName from Performance Monitor Users" -ForegroundColor Green
}
catch 
{
    Write-Host "Could not find IIS AppPool\$SitecoreSiteName to Performance Monitor Users" -ForegroundColor Yellow
}