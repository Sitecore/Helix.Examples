
Import-Module .\install-modules\helix.examples.menu.psm1
Import-Module .\install-modules\helix.examples.psm1

@'

 .d8888b.  d8b 888                                                  888    888          888 d8b          
d88P  Y88b Y8P 888                                                  888    888          888 Y8P          
Y88b.          888                                                  888    888          888              
 "Y888b.   888 888888 .d88b.   .d8888b .d88b.  888d888 .d88b.       8888888888  .d88b.  888 888 888  888 
    "Y88b. 888 888   d8P  Y8b d88P"   d88""88b 888P"  d8P  Y8b      888    888 d8P  Y8b 888 888 `Y8bd8P' 
      "888 888 888   88888888 888     888  888 888    88888888      888    888 88888888 888 888   X88K   
Y88b  d88P 888 Y88b. Y8b.     Y88b.   Y88..88P 888    Y8b.          888    888 Y8b.     888 888 .d8""8b. 
 "Y8888P"  888  "Y888 "Y8888   "Y8888P "Y88P"  888     "Y8888       888    888  "Y8888  888 888 888  888 

8888888888                                          888                                                  
888                                                 888                                                  
888                                                 888                                                  
8888888    888  888  8888b.  88888b.d88b.  88888b.  888  .d88b.  .d8888b                                 
888        `Y8bd8P'     "88b 888 "888 "88b 888 "88b 888 d8P  Y8b 88K                                     
888          X88K   .d888888 888  888  888 888  888 888 88888888 "Y8888b.                                
888        .d8""8b. 888  888 888  888  888 888 d88P 888 Y8b.          X88                                
8888888888 888  888 "Y888888 888  888  888 88888P"  888  "Y8888   88888P'                                
                                           888                                                           
                                           888                                                           
                                           888                                                           


---------------------------- helix.sitecore.net -----------------------------------

The Helix.Examples source code, tools and processes are examples of Sitecore Helix.
They are not supported by Sitecore and should be used at your own risk.

-----------------------------------------------------------------------------------

'@ -split "`n" | % { Write-HostHelix $_ -ForegroundColor Red }

Function Request-UserConfiguration {
    # Read in user and global veriables so we can get existing values and test input
    . $PSScriptRoot\settings.global.ps1

    $UserSettings = [ordered]@{
        SqlServer = [pscustomobject]@{
            Prompt = "The host and instance name of your SQL Server (e.g. (local) or .\SQLEXPRESS)."
            NewValue = $null
        }
        SqlAdminUser = [pscustomobject]@{
            Prompt = "The username of the SQL user which will be used to install Sitecore. Should be 'sa' or have sysadmin role."
            NewValue = $null
        }
        SqlAdminPassword = [pscustomobject]@{
            Prompt = "The user's password. NOTE: This will be stored in plain text."
            NewValue = $null
        }
        SolrUrl = [pscustomobject]@{
            Prompt = "The URL of your Solr instance (e.g. https://localhost:8983/solr)"
            NewValue = $null
        }
        SolrRoot = [pscustomobject]@{
            Prompt = "The filesystem path of your Solr instance (e.g. C:\solr\solr-X.Y.Z)"
            NewValue = $null
        }
        SolrService = [pscustomobject]@{
            Prompt = "The name of your Solr Windows service (e.g. Solr-X.Y.Z)"
            NewValue = $null
        }
    }

    Write-HostHelix "Please fill in the following values to enable local install of the Helix Examples." -ForegroundColor yellow
    Write-HostHelix "The values will be tested and written to settings.user.ps1." -ForegroundColor yellow
    $UserSettings.GetEnumerator() | % {
        $variable = "`$$($_.Name)"
        # Default to previously entered values
        $currentValue = $_.Value.NewValue
        if (-not $currentValue) {
            # Otherwise try value from existing config
            $currentValue = Invoke-Expression $variable
        }
        Write-HostHelix
        Write-HostHelix "$($variable): $($_.Value.Prompt)"
        if ($currentValue) {
            Write-HostHelix "[Press enter to keep value $currentValue]"
        }
        Write-HostHelix "> " -ForegroundColor yellow -NoNewline
        $_.Value.NewValue = Read-Host
        if (-not $_.Value.NewValue) {
            # Use previously entered or existing value
            $_.Value.NewValue = $currentValue
        }
    }

    try {
        Write-HostHelix
        Write-HostHelix "Testing SQL values..." -ForegroundColor yellow
        Write-HostHelix

        $result = Test-SqlConnection `
            -SqlServer $UserSettings["SqlServer"].NewValue `
            -SqlBuildVersion $SqlBuildVersion `
            -SqlFriendlyVersion $SqlFriendlyVersion `
            -SqlAdminUser $UserSettings["SqlAdminUser"].NewValue `
            -SqlAdminPassword  $UserSettings["SqlAdminPassword"].NewValue `
            3>&1 6>&1
        $result -split "`n" | % { Write-HostHelix $_ }

        Write-HostHelix
        Write-HostHelix "Testing Solr values..." -ForegroundColor yellow
        Write-HostHelix

        $result = Test-SolrUrl -SolrUrl $UserSettings['SolrUrl'].NewValue 3>&1 6>&1
        $result -split "`n" | % { Write-HostHelix $_ }
        $result = Test-SolrDirectory -SolrRoot $UserSettings['SolrRoot'].NewValue 3>&1 6>&1
        $result -split "`n" | % { Write-HostHelix $_ }
        $result = Test-SolrService -SolrService $UserSettings['SolrService'].NewValue 3>&1 6>&1
        $result -split "`n" | % { Write-HostHelix $_ }
    } catch {
        ($_ | Out-String) -split "`n" | % { Write-HostHelix $_ -ForegroundColor red }
        Write-HostHelix
        Write-HostHelix "Invalid values, please try again." -ForegroundColor yellow
        Press-AnyKey
        Request-UserConfiguration
        return
    }
    Write-HostHelix
    Write-HostHelix "Writing settings.user.ps1..." -ForegroundColor yellow
    $settingsFile =
@"
# SQL Parameters
`$SqlServer = "$($UserSettings["SqlServer"].NewValue)"
`$SqlAdminUser = "$($UserSettings["SqlAdminUser"].NewValue)"
`$SqlAdminPassword = "$($UserSettings["SqlAdminPassword"].NewValue)"

# Solr Parameters
`$SolrUrl = "$($UserSettings["SolrUrl"].NewValue)"
`$SolrRoot = "$($UserSettings["SolrRoot"].NewValue)"
`$SolrService = "$($UserSettings["SolrService"].NewValue)"
"@
    $settingsFile -split "`n" | % { Write-HostHelix $_ -ForegroundColor DarkGray }
    $settingsFile | Set-Content settings.user.ps1
    Write-HostHelix
    Write-HostHelix "Configuration complete. If you haven't installed Sitecore before, use <v>alidate to verify prerequisites."
    Write-HostHelix
    Press-AnyKey
}

Function Write-InstanceMenu($instance) {
    $commands = @()
    if ($instance.Installed) {
        $commands += [pscustomobject]@{
            Command = "u"
            Title = "Uninstall"
            Script = {
                param($instance)
                Write-HostHelix "Invoking $($instance.UninstallScript)"
                try {
                    & $instance.UninstallScript
                    if ($?) {
                        Write-HostHelix
                        Write-HostHelix "Uninstall complete!" -ForegroundColor yellow
                        Press-AnyKey
                    }
                }
                catch {
                    Write-HostHelix
                    Write-HostHelix "Uninstall error, see details above." -ForegroundColor red
                    Press-AnyKey
                }

                # back out a couple steps and re-write instance list
                # (with updated install status)
                Pop-Menu
                Pop-Menu
                Write-InstanceListMenu
            }
            ScriptArgs = @($instance)
        }
    } else {
        $commands += [pscustomobject]@{
            Command = "i"
            Title = "Install"
            Script = {
                param($instance)
                Write-HostHelix "Invoking $($instance.InstallScript)"
                try {
                    & $instance.InstallScript
                    if ($?) {
                        Write-HostHelix
                        Write-HostHelix "Install complete!" -ForegroundColor yellow
                        Write-HostHelix
                        Write-HostHelix "Let's make sure the content publish is complete..."
                        10..0 | % { Write-HostHelix $_; Start-Sleep 1 }
                        Write-HostHelix

                        $loginUrl = "$($instance.SitecoreUrl)/sitecore/login/"
                        Write-HostHelix "Opening $loginUrl..."
                        Start-Process $loginUrl
                        Write-HostHelix "Opening $($instance.SitecoreUrl)..."
                        Start-Process $instance.SitecoreUrl
                        Write-HostHelix "sitecore\admin password is '$($instance.AdminPassword)'" -ForegroundColor yellow
                        Write-HostHelix

                        Press-AnyKey
                    }
                }
                catch {
                    Write-HostHelix
                    Write-HostHelix "Install error, see details above." -ForegroundColor red
                    Press-AnyKey
                }

                # back out a couple steps and re-write instance list
                # (with updated install status, even if install failed)
                Pop-Menu
                Pop-Menu
                Write-InstanceListMenu
            }
            ScriptArgs = @($instance)
        }
    }

    $menu = [pscustomobject]@{
        Title = "Helix Example - $($instance.Name)"
        DescriptionLines = @(
            $instance.Description,
            "Find out more: $($instance.ExampleUrl)",
            "",
            "Source Path: $($instance.SourcePath)",
            "Install Path: $($instance.WebRoot)",
            "Install URL: $($instance.SitecoreUrl)"
        )
        Commands = $commands
    }
    Push-Menu -Menu $menu
}

Function Write-InstanceListMenu() {
    $instanceId = 0
    $instances = Get-ChildItem -r -Path examples\*\build\settings.ps1 | % {
        $instanceId++
        $script = {
            . $_.FullName
            return [pscustomobject]@{
                Id = $instanceId
                Name = $ExampleName
                Description = $ExampleDescription
                ExampleUrl = $ExampleUrl
                SitecoreUrl = $SitecoreSiteUrl
                WebRoot = $SitecoreSiteRoot
                SourcePath = $ExampleSrcPath
                AdminPassword = $SitecoreAdminPassword
                Installed = (Test-Path $SitecoreSiteRoot)
                InstallScript = $InstallScript
                UninstallScript = $UninstallScript
            }
        }
        Invoke-Command $script
    }

    $commands = $instances | % {
        $title = $_.Name
        if ($_.Installed) {
            $title += " (installed)"
        }
        [pscustomobject]@{
            Command = $_.Id
            Title = $title
            Script = {
                param($instance)
                Write-InstanceMenu -instance $instance
            }
            ScriptArgs = @($_)
        }
    }

    $menu = [pscustomobject]@{
        Title = "Available Examples"
        DescriptionLines = @(
            "An `"(installed)`" flag indicates the web root for the instance appears to exist."
        )
        Commands = $commands
    }
    Push-Menu -Menu $menu
}

function Write-MainMenu {
    $menu = [pscustomobject]@{
        Title = "Welcome"
        Commands = @(
            [pscustomobject]@{
                Command = "c"
                Title = "Configure Install Settings"
                Script = {
                    Request-UserConfiguration
                }
            },
            [pscustomobject]@{
                Command = "v"
                Title = "Validate your configuration and install prerequisites"
                Script = {
                    try {
                        & $PSScriptRoot\prepare.ps1
                    }
                    catch {
                        Write-HostHelix
                        Write-HostHelix "Validation/prerequisites error, see details above." -ForegroundColor red
                    }
                    
                    Write-HostHelix
                    Press-AnyKey
                }
            },
            [pscustomobject]@{
                Command = "l"
                Title = "List/(Un)Install Examples"
                Script = {
                    Write-InstanceListMenu
                }
            },
            [pscustomobject]@{
                Command = "a"
                Title = "About Helix Examples"
                Script = {
                    Write-HostHelix "--------------------------------------------     Sitecore Helix      ------------------------------------------------------" -ForegroundColor yellow
                    Write-HostHelix "Sitecore Helix defines recommended practices and conventions to help improve the maintainability of Sitecore solutions."
                    Write-HostHelix "It's based on the Principles of Packages Design by Robert C Martin."
                    Write-HostHelix
                    Write-HostHelix "More info on Sitecore Helix can be found at: https://helix.sitecore.net"
                    Write-HostHelix
                    Write-HostHelix "-------------------------------------------- Sitecore Helix Examples ------------------------------------------------------" -ForegroundColor yellow
                    Write-HostHelix "The Sitecore Helix Examples are demonstrations of Sitecore Helix practices across various tooling and business scenarios."
                    Write-HostHelix "They are intended to demonstrate a wider variety of implementation types / requirements than existing examples."
                    Write-HostHelix
                    Write-HostHelix "The Helix Examples are not:"
                    Write-HostHelix "  > Sales/Marketing demo sites (see Habitat Home)"
                    Write-HostHelix "  > A 'getting started' guide for Sitecore (see https://doc.sitecore.com/developers) "
                    Write-HostHelix "  > A 'starter kit' for Helix-based sites (there are several of these in the community)"
                    Write-HostHelix
                    Write-HostHelix "You can certainly reference and reuse code found here. However you should take care when doing so, like you could copying code from"
                    Write-HostHelix "Stackexchange or other sources, and adjust to your needs. As much as possible, these examples strive to follow good Sitecore practices beyond Helix."
                    Write-HostHelix
                    Write-HostHelix "The install/menu/configuration system however is optimized to ease and bring joy to the installation of the multiple example instances,"
                    Write-HostHelix "and likely is not a good fit for production projects. However we do hope you enjoy using it."
                    Write-HostHelix
                    Write-HostHelix "For more info on Helix Examples, visit https://sitecore.github.io/Helix.Examples/"
                    Write-HostHelix
                    Press-AnyKey
                }
            }
        )
    }
    Initialize-Menu
    Push-Menu -Menu $menu
    Write-Menu
}


if (-not (Test-Path $PSScriptRoot\settings.user.ps1)) {
    Request-UserConfiguration
}

Write-MainMenu