
param(
  [Parameter(Mandatory = $true)]
  [string]$sitecoreContainerName
  ,
  [Parameter(Mandatory = $true)]
  [string]$hostname
)



  $dockerId = docker ps -q --filter name=${sitecoreContainerName}

  ##elevating PS if necessary
  if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File "$PSCommandPath"" -Verb RunAs; exit }

  ##Remove existing line
  Set-Content -Path "$env:windir\System32\Drivers\etc\hosts" -Value (get-content -Path "$env:windir\System32\Drivers\etc\hosts" | Select-String -Pattern $hostname -NotMatch)

  ##add ip:host mapping to host file
  $ipadd = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $dockerId
  Add-Content -Value "${ipadd} $hostname" -Path "$env:windir\System32\Drivers\etc\hosts"

