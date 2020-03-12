[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$LicenseXmlPath,
    [Parameter(Mandatory = $false)]
    [string]$Registry = "local"
)

function GetLicenseBase64String($path)
{
    $licenseFileStream = [System.IO.File]::OpenRead($Path);
    $licenseString = $null

    try
    {
        $memory = [System.IO.MemoryStream]::new()

        $gzip = [System.IO.Compression.GZipStream]::new($memory, [System.IO.Compression.CompressionLevel]::Optimal, $false);
        $licenseFileStream.CopyTo($gzip);
        $gzip.Close();

        # base64 encode the gzipped content
        $licenseString = [System.Convert]::ToBase64String($memory.ToArray())
    }
    finally
    {
        # cleanup
        if ($null -ne $gzip)
        {
            $gzip.Dispose()
            $gzip = $null
        }

        if ($null -ne $memory)
        {
            $memory.Dispose()
            $memory = $null
        }

        $licenseFileStream = $null
    }

    # sanity check
    if ($licenseString.Length -le 100)
    {
        throw "Unknown error, the gzipped and base64 encoded string '$licenseString' is too short."
    }

    return $licenseString
}

# Get Sitecore license as Base-64 string
if (-not (Test-Path $LicenseXmlPath)) {
    throw "Did not find $LicenseXmlPath."
}
$license = GetLicenseBase64String($LicenseXmlPath)

# Set registry and license in .env file
$envFile = (Join-Path $PSScriptRoot ".env")

(Get-Content $envFile) | ForEach-Object { 
    $_ -replace "^REGISTRY=.*", "REGISTRY=$Registry/" `
       -replace "^SITECORE_LICENSE=.*", "SITECORE_LICENSE=$license" 
} | Set-Content $envFile

# Start everything up!
docker-compose up --build -d