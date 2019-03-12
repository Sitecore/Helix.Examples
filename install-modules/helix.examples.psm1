$ErrorActionPreference = 'Stop'

Function Invoke-ParseUnicornSecretFunction {
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

Function Invoke-SitecoreWarmup {
    Param(
		[string]$SitecoreUrl,
        [Int32]$TimeoutSec = 600
    )

    Write-Information "Warming up Sitecore instance at $SitecoreUrl"
    $result = Invoke-WebRequest -Uri "$SitecoreUrl/sitecore/service/keepalive.aspx" -TimeoutSec $TimeoutSec
    Write-Information "$($result.StatusCode) $($result.StatusDescription)"
}

Register-SitecoreInstallExtension -Command Invoke-ParseUnicornSecretFunction -As ParseUnicornSecret -Type ConfigFunction
Register-SitecoreInstallExtension -Command Invoke-SitecoreWarmup -As SitecoreWarmup -Type Task