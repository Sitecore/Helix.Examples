param([switch]$SkipPrerequisites)
$ErrorActionPreference = 'Stop'

. $PSScriptRoot\settings.ps1
if (Test-Path $PSScriptRoot\settings.user.ps1) {
    . $PSScriptRoot\settings.user.ps1
}

Write-Host "*******************************************************" -ForegroundColor Green
Write-Host " Installing Sitecore $SitecoreVersion" -ForegroundColor Green
Write-Host " Sitecore: $SitecoreSiteName" -ForegroundColor Green
Write-Host " xConnect: $XConnectSiteName" -ForegroundColor Green
Write-Host " Identity: $IdentityServerSiteName" -ForegroundColor Green
Write-Host "*******************************************************" -ForegroundColor Green

function Import-SitecoreInstallFramework {
    #Register Assets PowerShell Repository
    if ((Get-PSRepository | Where-Object {$_.Name -eq $AssetsPSRepositoryName}).count -eq 0) {
        Write-Host "Registering PS Repository $AssetsPSRepositoryName as $AssetsPSRepository" -ForegroundColor Green
        Register-PSRepository -Name $AssetsPSRepositoryName -SourceLocation $AssetsPSRepository -InstallationPolicy Trusted
    }

    #Install and Import SIF
    #Write-Host "Removing SIF if already loaded" -ForegroundColor Green
    #try { Remove-Module SitecoreInstallFramework } catch {}
    #$module = Get-InstalledModule -Name SitecoreInstallFramework -RequiredVersion $InstallerVersion -ErrorAction SilentlyContinue
    #if (-not $module) {
    #    Write-Host "Installing the Sitecore Install Framework, version $InstallerVersion" -ForegroundColor Green
    #    Install-Module SitecoreInstallFramework -RequiredVersion $InstallerVersion -Scope CurrentUser -Repository $AssetsPSRepositoryName
    #}
    #Write-Host "Loading the Sitecore Install Framework, version $InstallerVersion" -ForegroundColor Green
    #Import-Module SitecoreInstallFramework -RequiredVersion $InstallerVersion
}

function Install-Prerequisites {
    #Verify SQL version
    $SqlRequiredVersion = "13.0.4001"
    [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null
    $srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $SqlServer
    if (-not $srv -or -not $srv.Version) {
        throw "Could not find SQL Server '$SqlServer', check settings.ps1"
    }
    $minVersion = New-Object System.Version($RequiredSqlVersion)
    if ($srv.Version.CompareTo($minVersion) -lt 0) {
        throw "Invalid SQL version. Expected SQL 2016 SP1 (13.0.4001.0) or over."
    }
    
    #Enable Contained Databases
    Write-Host "Enable contained databases" -ForegroundColor Green
    try
    {
        Invoke-Sqlcmd -ServerInstance $SqlServer `
                      -Username $SqlAdminUser `
                      -Password $SqlAdminPassword `
                      -InputFile "$PSScriptRoot\build\database\containedauthentication.sql"
    }
    catch
    {
        write-host "Set Enable contained databases failed" -ForegroundColor Red
        throw
    }

    #Verify Solr
    Write-Host "Verifying Solr connection" -ForegroundColor Green
    if (-not $SolrUrl.ToLower().StartsWith("https")) {
        throw "Solr URL ($SolrUrl) must be secured with https"
    }
	$SolrRequest = [System.Net.WebRequest]::Create($SolrUrl)
	$SolrResponse = $SolrRequest.GetResponse()
	try {
		If ($SolrResponse.StatusCode -ne 200) {
			throw "Could not contact Solr on '$SolrUrl'. Response status was '$SolrResponse.StatusCode'"
		}
	}
	finally {
		$SolrResponse.Close()
    }
    
    Write-Host "Verifying Solr directory" -ForegroundColor Green
    if(-not (Test-Path "$SolrRoot\server")) {
        throw "The Solr root path '$SolrRoot' appears invalid. A 'server' folder should be present in this path to be a valid Solr distributive."
    }

    Write-Host "Verifying Solr service" -ForegroundColor Green
    try {
        $null = Get-Service $SolrService
    } catch {
        throw "The Solr service '$SolrService' does not exist. Perhaps it's incorrect in settings.ps1?"
    }

    #Run Prerequisites Config
    Install-SitecoreConfiguration -Path $PrerequisitiesConfiguration
}

function Install-Assets {
    #Verify that manual assets are present
    if (!(Test-Path $AssetsRoot)) {
        throw "$AssetsRoot not found"
    }

    #Verify license file
    if (!(Test-Path $LicenseFile)) {
        throw "License file $LicenseFile not found"
    }
    
    #Verify Sitecore package
    if (!(Test-Path $SitecorePackage)) {
        throw "Sitecore package $SitecorePackage not found"
    }
    
    #Verify xConnect package
    if (!(Test-Path $XConnectPackage)) {
        throw "XConnect package $XConnectPackage not found"
    }
}

function Expand-Install-Assets {
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
        write-host "Expanding install assets failed" -ForegroundColor Red
        throw
    }
    finally {
        Pop-Location
    }
}

function Install-XP0SingleDeveloper {
    Push-Location $ConfigPath
    $singleDeveloperParams = @{
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
        Install-SitecoreConfiguration @singleDeveloperParams *>&1 | Tee-Object "$PSScriptRoot\install.log"
    }
    catch
    {
        write-host "Install and deploy failed" -ForegroundColor Red
        throw
    }
    finally {
        Pop-Location
    }
}

function Add-AppPool-Membership {

    #Add ApplicationPoolIdentity to performance log users to avoid Sitecore log errors (https://kb.sitecore.net/articles/404548)
    
    try 
    {
        Add-LocalGroupMember "Performance Log Users" "IIS AppPool\$SitecoreSiteName"
        Write-Host "Added IIS AppPool\$SitecoreSiteName to Performance Log Users" -ForegroundColor Green
    }
    catch 
    {
        Write-Host "Warning: Couldn't add IIS AppPool\$SitecoreSiteName to Performance Log Users -- user may already exist" -ForegroundColor Yellow
    }
    try 
    {
        Add-LocalGroupMember "Performance Monitor Users" "IIS AppPool\$SitecoreSiteName"
        Write-Host "Added IIS AppPool\$SitecoreSiteName to Performance Monitor Users" -ForegroundColor Green
    }
    catch 
    {
        Write-Host "Warning: Couldn't add IIS AppPool\$SitecoreSiteName to Performance Monitor Users -- user may already exist" -ForegroundColor Yellow
    }
}

Import-SitecoreInstallFramework
Expand-Install-Assets
Install-XP0SingleDeveloper
Add-AppPool-Membership