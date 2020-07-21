$ErrorActionPreference = 'Stop'

$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

# This is an example PowerShell script that will execute a Unicorn sync.
# Intended to be invoked within a container shell session or by using 'docker exec'.
# From https://github.com/SitecoreUnicorn/Unicorn/blob/master/doc/PowerShell%20Remote%20Scripting/sample.ps1

Import-Module $ScriptPath\Unicorn.psm1

# Sync using the same environment variable that is used in our Unicorn configuration
Sync-Unicorn -ControlPanelUrl 'http://localhost/unicorn.aspx' -SharedSecret $env:UNICORN_SHARED_SECRET