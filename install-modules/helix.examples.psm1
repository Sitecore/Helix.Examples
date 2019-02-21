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

Register-SitecoreInstallExtension -Command Invoke-ParseUnicornSecretFunction -As ParseUnicornSecret -Type ConfigFunction