[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$TargetPath,
    [Parameter(Mandatory = $true)]
    [string]$XdtPath,
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$XdtDllPath
)

if (-not (Test-Path $XdtPath -PathType Container)) {
    Write-Verbose "Transformations source '$XdtPath' does not exist."
    return
}

$transformations = @(Get-ChildItem $XdtPath -File -Recurse)

if ($transformations.Length -eq 0) {
    Write-Verbose "No transformations in '$XdtPath'."
    return
}

Add-Type -Path $XdtDllPath

$transformations | ForEach-Object {
    $targetFullPath = (Resolve-Path $TargetPath).Path
    $xdtFullPath = (Resolve-Path $XdtPath).Path
    $targetFilePath = $_.FullName.Replace($xdtFullPath, $targetFullPath).Replace(".xdt", "")

    $targetDocument = New-Object Microsoft.Web.XmlTransform.XmlTransformableDocument;
    $targetDocument.PreserveWhitespace = $true
    $targetDocument.Load($targetFilePath)

    $transformation = New-Object Microsoft.Web.XmlTransform.XmlTransformation($_.FullName)
    if ($transformation.Apply($targetDocument) -eq $false) {
        throw "Transformation '$($_.FullName)' on '$($targetFilePath.FullName)' failed."
    }
    
    $targetDocument.Save($targetFilePath)
    Write-Verbose "Transformation '$($_.FullName)' on '$($targetFilePath.FullName)' completed."
}