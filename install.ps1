
Import-Module .\install-modules\helix.examples.menu.psm1

$logoLines =
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

'@ -split "`n"

for ($i = 0; $i -lt $logoLines.Length; $i++) {
    Write-HostHelix $logoLines[$i] -ForegroundColor Red
}



$instances = @(
    [pscustomobject]@{
        Id = 1
        Name = "Basic Company - TDS"
        Description = "This Helix Example shows lorem ipsum dolor"
        WebRoot = "C:\inetpub\wwwroot\helix-basic-tds.dev.local"
        Installed = $False
    },
    [pscustomobject]@{
        Id = 2
        Name = "Basic Company - TDS Consolidated"
        Description = "This Helix Example shows lorem ipsum dolor"
        WebRoot = "C:\inetpub\wwwroot\helix-basic-tds-consolidated.dev.local"
        Installed = $False
    },
    [pscustomobject]@{
        Id = 3
        Name = "Basic Company - Unicorn"
        Description = "This Helix Example shows lorem ipsum dolor"
        WebRoot = "C:\inetpub\wwwroot\helix-basic-unicorn.dev.local"
        Installed = $True
    },
    [pscustomobject]@{
        Id = 4
        Name = "Franchise"
        Description = "This Helix Example shows lorem ipsum dolor"
        WebRoot = "C:\inetpub\wwwroot\helix-franchise.dev.local"
        Installed = $False
    },
    [pscustomobject]@{
        Id = 5
        Name = "Corporate"
        Description = "This Helix Example shows lorem ipsum dolor"
        WebRoot = "C:\inetpub\wwwroot\helix-corporate.dev.local"
        Installed = $False
    }
)

Function Write-InstanceMenu($instance) {
    $commands = @()
    if ($instance.Installed) {
        $commands += [pscustomobject]@{
            Command = "u"
            Title = "Uninstall"
            Script = {
                Write-HostHelix "Let's uninstall!"
            }
        }
    } else {
        $commands += [pscustomobject]@{
            Command = "i"
            Title = "Install"
            Script = {
                Write-HostHelix -title "Let's install!"
            }
        }
    }

    $menu = [pscustomobject]@{
        Title = "Helix Example - $($instance.Name)"
        DescriptionLines = @($instance.Description,$instance.WebRoot)
        Commands = $commands
    }
    Push-Menu -Menu $menu
}

Function Write-InstanceListMenu($instances) {
    $commands = $instances | % {
        $title = $_.Name
        if ($_.Installed) {
            $title += " (installed)"
        }
        [pscustomobject]@{
            Command = $_.Id
            Title = $title
            Script = {
                $instanceId = [int]$args[0]
                $instance = $instances | ? { $_.Id -eq $instanceId } | select -first 1
                if (-not $instance) {
                    Write-HostHelix "Unknown instance $($args[0])"
                    Write-HostHelix
                } else {
                    Write-InstanceMenu -instance $instance
                }
            }
        }
    }

    $menu = [pscustomobject]@{
        Title = "Available Examples"
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
                    Write-HostHelix -title "Let's configure!"
                }
            },
            [pscustomobject]@{
                Command = "l"
                Title = "List/(Un)Install Examples"
                Script = {
                    Write-InstanceListMenu -instances $instances
                }
            },
            [pscustomobject]@{
                Command = "a"
                Title = "About Helix Examples"
                Script = {
                    Write-HostHelix "~~~~~Not a starter kit~~~~~~"
                    Write-HostHelix
                    Press-AnyKey
                }
            }
        )
    }
    Push-Menu -Menu $menu
    Write-Menu
}

Write-MainMenu