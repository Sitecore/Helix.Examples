# Solution parameters
$SolutionPrefix = "basic-company-ppmu"
$SitePostFix = "dev.local"
$webroot = "C:\inetpub\wwwroot"

$BuildProject = "$PSScriptRoot\..\src\Deployment\Website\Website.csproj"
$UnicornSecretConfig = "$PSScriptRoot\..\src\Foundation\Serialization\website\App_Config\Include\Unicorn.SharedSecret.config"

$SitecoreVersion = "9.1.0 rev. 001564"
$IdentityServerVersion = "2.0.0 rev. 00157"
$InstallerVersion = "2.0.0"

# Assets and prerequisites
# root is relative to config path
$AssetsRoot = "..\..\..\..\install-assets"
$AssetsPSRepository = "https://sitecore.myget.org/F/sc-powershell/api/v2/"
$AssetsPSRepositoryName = "SitecoreGallery"

$LicenseFile = "$AssetsRoot\license.xml"

# Certificates
$CertPath = Join-Path "$AssetsRoot" "Certificates"

# SQL Parameters
$SqlServer = "."
$SqlAdminUser = "sa"
$SqlAdminPassword = "12345"

# XP0 zip -- will be expanded in place if needed
$DownloadZip = "$AssetsRoot\Sitecore $SitecoreVersion (WDP XP0 packages).zip"
$ConfigurationsZip = "XP0 Configuration files $SitecoreVersion.zip"

# Build config
$ConfigPath = ".\config"
$PrerequisitiesConfiguration = "Prerequisites.json"
$ExpandAssetsConfiguration = "expand-install-assets.json"
$SingleDeveloperConfiguration = "install-and-deploy.json"

# Sitecore Parameters
$SitecorePackage = "$AssetsRoot\Sitecore $SitecoreVersion (OnPrem)_single.scwdp.zip"
$SitecoreSiteName = "$SolutionPrefix.$SitePostFix"
$SitecoreSiteUrl = "http://$SitecoreSiteName"
$SitecoreSiteRoot = Join-Path $webroot -ChildPath $SitecoreSiteName
$SitecoreAdminPassword = "b"

# XConnect Parameters
$XConnectPackage = "$AssetsRoot\Sitecore $SitecoreVersion (OnPrem)_xp0xconnect.scwdp.zip"
$XConnectSiteName = "${SolutionPrefix}_xconnect.$SitePostFix"
$XConnectSiteUrl = "https://$XConnectSiteName"
$XConnectSiteRoot = Join-Path $webroot -ChildPath $XConnectSiteName

# Identity Server Parameters
$IdentityServerSiteName = "${SolutionPrefix}_IdentityServer.$SitePostFix"
$IdentityServerUrl = "https://$IdentityServerName"
$IdentityServerPackage = "$AssetsRoot\Sitecore.IdentityServer $IdentityServerVersion (OnPrem)_identityserver.scwdp.zip"
$IdentityClientSecret = "SPDHZpF6g8EXq5F7C5EhPQdsC1UbvTU3"
$IdentityAllowedCorsOrigins = $SitecoreSiteUrl
$IdentityServerSiteRoot = Join-Path $webroot -ChildPath $IdentityServerSiteName

# Solr Parameters
$SolrUrl = "https://localhost:8983/solr"
$SolrRoot = "c:\\solr"
$SolrService = "Solr"
