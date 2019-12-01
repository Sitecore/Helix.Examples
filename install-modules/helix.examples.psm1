$ErrorActionPreference = 'Stop'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

Function Import-SitecoreInstallFramework {
    Param(
        [string]$InstallerVersion
    )

    $module = Get-Module SitecoreInstallFramework
    if ($module -and $module.Version.ToString() -eq $InstallerVersion) {
        Write-Host "Sitecore Install Framework $InstallerVersion already loaded"
        return
    }
    if ($module) {
        # Remove SIF if already loaded to ensure correct version
        Remove-Module SitecoreInstallFramework
    }

    # Ensure correct version is installed
    $installedModule = Get-InstalledModule -Name SitecoreInstallFramework -RequiredVersion $InstallerVersion -ErrorAction SilentlyContinue
    if (-not $installedModule) {
        Write-Error ("You need to install SitecoreInstallFramework $InstallerVersion from the Sitecore PowerShell Gallery.`n" +
                     "For more information: https://doc.sitecore.com/developers/91/sitecore-experience-management/en/sitecore-powershell-public-nuget-feed-faq.html")
    }

    Write-Host "Loading the Sitecore Install Framework, version $InstallerVersion"
    Import-Module SitecoreInstallFramework -Force -RequiredVersion $InstallerVersion -Scope Global
}

Function Initialize-InstallAssets {
    param(
        $ConfigPath,
        $PrepareAssetsConfiguration,
        $InstallTemp,
        $DownloadZip,
        $AssetsRoot,
        $ConfigurationsZip,
        $ExampleConfigPath
    ) 
    $additionalConfigs = @("$ConfigPath\*.json")
    if ($ExampleConfigPath) {
        $additionalConfigs += "$ExampleConfigPath\*.json"
    }

    Push-Location $ConfigPath
    $expandAssetsParams = @{
        Path = $PrepareAssetsConfiguration
        InstallTemp = $InstallTemp
        DownloadZip = $DownloadZip
        AssetsPath = $AssetsRoot
        ConfigurationsZip = $ConfigurationsZip
        AdditionalConfigs = $additionalConfigs
    }
    try {
        Install-SitecoreConfiguration @expandAssetsParams
    }
    catch
    {
        Write-Host "Preparing install assets failed" -ForegroundColor Red
        throw
    }
    finally {
        Pop-Location
    }
}

Function Test-InstallZip {
    Param(
        [string]$DownloadZipPath
    )
    if (-not (Test-Path $DownloadZipPath)) {
        throw "Did not find $DownloadZipPath, please download from http://dev.sitecore.net and copy to 'install-assets'."
    }
}

Function Test-LicenseXml {
    Param(
        [string]$LicenseXmlPath
    )
    if (-not (Test-Path $LicenseXmlPath)) {
        throw "Did not find $LicenseXmlPath, please copy your license.xml to 'install-assets'."
    }
}

Function Test-SqlConnection {
    Param(
        [string]$SqlServer,
        [string]$SqlBuildVersion,
        [string]$SqlFriendlyVersion,
        [string]$SqlAdminUser,
        [string]$SqlAdminPassword
    )

    Write-Information "Verifying SQL Server connection at $SqlServer"
    [reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | out-null
    $srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $SqlServer
    if (-not $srv -or -not $srv.Version) {
        throw "Could not find SQL Server '$SqlServer'"
    }
    $minVersion = New-Object System.Version($SqlBuildVersion)
    if ($srv.Version.CompareTo($minVersion) -lt 0) {
        throw "Invalid SQL version $($srv.Version). Expected SQL Server $SqlFriendlyVersion ($SqlBuildVersion) or over."
    }
    Write-Information "Found SQL Server $($srv.Version)"

    $roleCommand = @"
SELECT spU.name, MAX(CASE WHEN srm.role_principal_id = 3 THEN 1 END) AS sysadmin
FROM sys.server_principals AS spR
JOIN sys.server_role_members AS srm ON spR.principal_id = srm.role_principal_id
JOIN sys.server_principals AS spU ON srm.member_principal_id = spU.principal_id
WHERE spR.[type] = 'R' AND spU.name = `$(username)
GROUP BY spU.name
"@
    try {
        $roleInfo = Invoke-Sqlcmd -ServerInstance $SqlServer `
            -Username $SqlAdminUser `
            -Password $SqlAdminPassword `
            -Query $roleCommand `
            -Variable @(
                "username = '$SqlAdminUser'"
            )
        if ($roleInfo.sysadmin -ne 1) {
            throw "SQL user $SqlAdminUser does not have the 'sysadmin' role."
        } else {
            Write-Information "Found sysadmin user $SqlAdminUser"
        }
    }
    catch {
        Write-Warning "Login or role check failed for SQL user $SqlAdminUser on $SqlServer."
        throw
    }
    Write-Information "OK"
}

Function Enable-SqlContainedDatabases {
    Param(
        [string]$SqlServer,
        [string]$SqlAdminUser,
        [string]$SqlAdminPassword
    )

    $command = @"
sp_configure 'contained database authentication', 1;  
GO  
RECONFIGURE;  
GO
"@
    Write-Information "Enabling contained databases on $SqlServer"
    try
    {
        Invoke-Sqlcmd -ServerInstance $SqlServer `
                      -Username $SqlAdminUser `
                      -Password $SqlAdminPassword `
                      -Query $command
        Write-Information "OK"
    }
    catch
    {
        Write-Warning "Enabling contained databases failed on $SqlServer"
        throw
    }

}

Function Test-SolrUrl {
    Param(
        [string]$SolrUrl
    )

    Write-Information "Verifying Solr connection at $SolrUrl"
    if (-not $SolrUrl.ToLower().StartsWith("https")) {
        throw "Solr URL ($SolrUrl) must be secured with https"
    }
    try {
        $SolrRequest = [System.Net.WebRequest]::Create($SolrUrl)
        $SolrResponse = $SolrRequest.GetResponse()
        If ($SolrResponse.StatusCode -ne 200) {
            throw "Could not contact Solr on '$SolrUrl'. Response status was '$SolrResponse.StatusCode'"
        }
        Write-Information "OK"
    }
    catch {
        Write-Warning "Testing Solr connection failed at $SolrUrl"
        throw
    }
    finally {
        if ($SolrResponse) {
            $SolrResponse.Close()
        }
    }
}

Function Test-SolrDirectory {
    Param(
        [string]$SolrRoot
    )

    Write-Information "Verifying Solr directory $SolrRoot"
    if(-not (Test-Path "$SolrRoot\server")) {
        throw "The Solr root path '$SolrRoot' appears invalid. A 'server' folder should be present in this path to be a valid Solr distributive."
    }
    Write-Information "OK"
}

Function Test-SolrService {
    Param(
        [string]$SolrService
    )

    Write-Host "Verifying Solr service $SolrService exists"
    try {
        $null = Get-Service $SolrService
        Write-Information "OK"
    } catch {
        throw "The Solr service '$SolrService' does not exist."
    }
}

Function Add-AppPoolToPerfmon {
    Param(
        [string]$SitecoreSiteName
    )

    #Add ApplicationPoolIdentity to performance log users to avoid Sitecore log errors (https://kb.sitecore.net/articles/404548)    
    try 
    {
        Add-LocalGroupMember "Performance Log Users" "IIS AppPool\$SitecoreSiteName"
        Write-Information "Added IIS AppPool\$SitecoreSiteName to Performance Log Users"
    }
    catch 
    {
        Write-Warning "Warning: Couldn't add IIS AppPool\$SitecoreSiteName to Performance Log Users -- user may already exist"
    }
    try 
    {
        Add-LocalGroupMember "Performance Monitor Users" "IIS AppPool\$SitecoreSiteName"
        Write-Information "Added IIS AppPool\$SitecoreSiteName to Performance Monitor Users"
    }
    catch 
    {
        Write-Warning "Warning: Couldn't add IIS AppPool\$SitecoreSiteName to Performance Monitor Users -- user may already exist"
    }
}

Function Remove-AppPoolFromPerfmon {
    Param(
        [string]$SitecoreSiteName
    )

    try 
    {
        Remove-LocalGroupMember "Performance Log Users" "IIS AppPool\$SitecoreSiteName"
        Write-Information "Removed IIS AppPool\$SitecoreSiteName from Performance Log Users"
    }
    catch 
    {
        Write-Warning "Could not find IIS AppPool\$SitecoreSiteName in Performance Log Users"
    }
    try 
    {
        Remove-LocalGroupMember "Performance Monitor Users" "IIS AppPool\$SitecoreSiteName"
        Write-Information "Removed IIS AppPool\$SitecoreSiteName from Performance Monitor Users"
    }
    catch 
    {
        Write-Warning "Could not find IIS AppPool\$SitecoreSiteName in Performance Monitor Users"
    }
}

Function Write-SiteHostNameConfigPatch {
    Param(
        [hashtable]$HostNames,
        [string]$DestinationPath
    )
    $xml = @"
<?xml version="1.0"?>
<configuration xmlns:set="http://www.sitecore.net/xmlconfig/set/">
    <sitecore>
        <sites>
            $($HostNames.Keys | % { "<site name=`"$_`" set:hostName=`"$($HostNames[$_])`" />`r`n" })
        </sites>
    </sitecore>
</configuration>
"@
    Write-Information "Config patch: $xml"
    $xml > $DestinationPath
    Write-Information "Wrote to $DestinationPath"
}

Import-Module "$PSScriptRoot\msbuild\Invoke-MsBuild.psm1"
Function Invoke-MsBuildWithFailureCheck {
    Param(
        [string]$Path,
        [string]$MsBuildParameters,
        [switch]$ShowBuildOutputInCurrentWindow,
        [switch]$KeepBuildLogOnSuccessfulBuilds
    )
    $buildArgs = @{
        Path = $Path
        MsBuildParameters = $MsBuildParameters
        ShowBuildOutputInCurrentWindow = $ShowBuildOutputInCurrentWindow
        KeepBuildLogOnSuccessfulBuilds = $true
    }
    $result = Invoke-MsBuild @buildArgs
    $result
    if ($result.BuildSucceeded -ne $true) {
        Write-Error "Build FAILED"
    }
}

Function Get-UnicornSecret {
    Param(
        [string]$ConfigPath
    )

    if (-not $ConfigPath) {
        return ""
    }

    if (-not (Test-Path $ConfigPath)) {
        throw "Invalid Unicorn config path for shared secret: $ConfigPath"
    }

    $secretConfig = [xml](Get-Content -Raw $ConfigPath)
    $secret = $secretConfig.configuration.sitecore.unicorn.authenticationProvider.SharedSecret
    if (-not $secret) {
        throw "Unable to find Unicorn shared secret in $ConfigPath"
    }
    return $secret
}

Function Write-SourceFolderConfigPatch {
    Param(
        [string]$SourceFolder,
        [string]$DestinationPath
    )
    $xml = @"
<?xml version="1.0"?>
<configuration xmlns:set="http://www.sitecore.net/xmlconfig/set/">
    <sitecore>
        <sc.variable name="sourceFolder" set:value="$SourceFolder" />
    </sitecore>
</configuration>
"@
    Write-Information "Config patch: $xml"
    $xml > $DestinationPath
    Write-Information "Wrote to $DestinationPath"
}

Function Write-PublishUserPath {
    Param(
        [string]$PublishPath,
        [string]$DestinationPath
    )
    $xml = @"
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
    <PropertyGroup>
        <publishUrl>$PublishPath</publishUrl>
    </PropertyGroup>
</Project>
"@
    Write-Information "MSBuild publish configuration: $xml"
    $xml > $DestinationPath
}

Function Write-EnableYamlConfigPatch {
    Param(
        [string]$DestinationPath
    )
    $xml = @"
<?xml version="1.0"?>
<configuration xmlns:patch="http://www.sitecore.net/xmlconfig/" xmlns:set="http://www.sitecore.net/xmlconfig/set/">
  <sitecore>
    <settings>
      <setting name="Serialization.SerializationType" set:value="YAML" />
    </settings>
  </sitecore>
</configuration>
"@
    Write-Information "Config patch: $xml"
    $xml > $DestinationPath
    Write-Information "Wrote to $DestinationPath"
}

Function Write-TdsGlobalUserConfig {
    Param(
        [string]$SitecoreWebUrl,
        [string]$SitecoreDeployFolder,
        [string]$DestinationPath
    )
    $xml = @"
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="3.5" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <PropertyGroup Condition=" '`$(Configuration)' == 'Debug' ">
    <SitecoreWebUrl>$SitecoreWebUrl</SitecoreWebUrl>
    <SitecoreDeployFolder>$SitecoreDeployFolder</SitecoreDeployFolder>
  </PropertyGroup>
</Project>
"@
    Write-Information "TdsGlobal.config.user configuration: $xml"
    $xml > $DestinationPath
    Write-Information "Wrote to $DestinationPath"
}
Function Invoke-SitecoreWarmup {
    Param(
        [string]$SitecoreUrl,
        [Int32]$TimeoutSec = 600
    )

    Write-Information "Warming up Sitecore instance at $SitecoreUrl"
    $result = Invoke-WebRequest -Uri "$SitecoreUrl/sitecore/service/keepalive.aspx" -TimeoutSec $TimeoutSec
    Write-Information "$($result.StatusCode) $($result.StatusDescription)"
}

Export-ModuleMember *-*