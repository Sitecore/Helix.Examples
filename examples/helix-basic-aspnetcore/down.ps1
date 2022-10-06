[CmdletBinding(DefaultParameterSetName = "no-arguments")]
Param (
    # use to run proper sitecore deployment setup
    [string]$Topology
)

$topologyArray = "xp0", "xp1", "xm1";

$startDirectory = ".\run\sitecore-";
$workinDirectoryPath;
$envCheck;
$envCheckVariable = "HOST_LICENSE_FOLDER";

if ($topologyArray.Contains($Topology))
{
  $envCheck = Get-Content (Join-Path -Path ($startDirectory + $Topology) -ChildPath .env) -Encoding UTF8 | Where-Object { $_ -imatch "^$envCheckVariable=.+" }
  if ($envCheck) {
    $workinDirectoryPath = $startDirectory + $Topology;
  }
}

Push-Location $workinDirectoryPath

Write-Host "Down containers..." -ForegroundColor Green
try {
  docker-compose down
  if ($LASTEXITCODE -ne 0) {
    Write-Error "Container down failed, see errors above."
  }
}
finally {
  Pop-Location
}
