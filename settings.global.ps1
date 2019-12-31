# Always execute relative to calling settings
param($ExampleBuildDirectory)

$SitecoreVersion = "9.3.0 rev. 003498"
$IdentityServerVersion = "4.0.0 rev. 00257"
$InstallerVersion = "2.2.0"

$SqlBuildVersion = "13.0.5026"
$SqlFriendlyVersion = "2016 SP2"

$SitePostFix = "dev.local"
$webroot = "C:\inetpub\wwwroot"

# Other user-configurable install params
$SitecoreAdminPassword = "b"
$IdentityClientSecret = "SPDHZpF6g8EXq5F7C5EhPQdsC1UbvTU3"

if ($ExampleBuildDirectory) {
    $ExampleSrcPath = (Get-Item "$ExampleBuildDirectory\..\src").FullName
    $ExampleConfigs = (Get-Item "$ExampleBuildDirectory\config").FullName
    $InstallScript = (Get-Item "$ExampleBuildDirectory\install.ps1").FullName
    $UninstallScript = (Get-Item "$ExampleBuildDirectory\uninstall.ps1").FullName
}

$InstallTemp = "$PSScriptRoot\.installtemp"
$ConfigPath = "$PSScriptRoot\sif-configs"
$PrepareAssetsConfiguration = "prepare-install-assets.json"
$PrepareConfiguration = "prepare.json"
$InstallConfiguration = "install.json"
$BuildAndSyncConfiguration = "build-and-sync.json"
$AssetsRoot = "$PSScriptRoot\install-assets"

# User overrides before we calculate values
if (Test-Path $PSScriptRoot\settings.user.ps1) {
    . $PSScriptRoot\settings.user.ps1
}

#
# CALCULATED SETTINGS
#

#License File
$LicenseFile = "$AssetsRoot\license.xml"

# Certificates
$CertPath = Join-Path "$AssetsRoot" "Certificates"

# XP0 zip -- will be expanded in place if needed
$DownloadZip = "$AssetsRoot\Sitecore $SitecoreVersion (WDP XP0 packages).zip"
$ConfigurationsZip = "XP0 Configuration files $SitecoreVersion.zip"

# Sitecore Parameters
$SitecorePackage = "$AssetsRoot\Sitecore $SitecoreVersion (OnPrem)_single.scwdp.zip"
$SitecoreSiteName = "$SolutionPrefix.$SitePostFix"
$SitecoreSiteUrl = "https://$SitecoreSiteName"
$SitecoreSiteRoot = Join-Path $webroot -ChildPath $SitecoreSiteName

# XConnect Parameters
$XConnectPackage = "$AssetsRoot\Sitecore $SitecoreVersion (OnPrem)_xp0xconnect.scwdp.zip"
$XConnectSiteName = "${SolutionPrefix}_xconnect.$SitePostFix"
$XConnectSiteUrl = "https://$XConnectSiteName"
$XConnectSiteRoot = Join-Path $webroot -ChildPath $XConnectSiteName

# Identity Server Parameters
$IdentityServerSiteName = "${SolutionPrefix}_IdentityServer.$SitePostFix"
$IdentityServerUrl = "https://$IdentityServerName"
$IdentityServerPackage = "$AssetsRoot\Sitecore.IdentityServer $IdentityServerVersion (OnPrem)_identityserver.scwdp.zip"
$IdentityAllowedCorsOrigins = $SitecoreSiteUrl
$IdentityServerSiteRoot = Join-Path $webroot -ChildPath $IdentityServerSiteName