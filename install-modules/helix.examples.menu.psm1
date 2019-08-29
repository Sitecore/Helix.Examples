$script:dnaLines =
@'
O---o
 O-o
  O
 o-O
o---O
O---o
 O-o
  O
 o-O
o---O
O---o
 O-o
  O
 o-O
o---O
O---o
 O-o
  O
 o-O
o---O
'@ -split "`n"

$script:dnaPos = 0

Function Write-HostHelix {
    Write-Host "$($dnaLines[$script:dnaPos])`t" -NoNewline -ForegroundColor Green
    $script:dnaPos++
    if ($script:dnaPos -eq $dnaLines.Length) {
        $script:dnaPos = 0
    }
    Write-Host @args
}

Function Press-AnyKey {
    Write-HostHelix "Press any key to continue..." -NoNewline
    $null = [Console]::ReadKey()
    Write-Host
    Write-HostHelix
}

Function Initialize-Menu {
    $script:MenuStack = New-Object System.Collections.Stack
}

Function Print-Menu([pscustomobject]$Menu) {
    $border = "==========================================================="
    $title = $Menu.Title
    if ($title.Length -lt $border.Length) {
        $pad = ($border.Length - $title.Length)/2
        $title = (' ' * $pad) + $title
    }

    Write-HostHelix $border -ForegroundColor yellow
    Write-HostHelix $title -ForegroundColor yellow
    Write-HostHelix $border -ForegroundColor yellow
    Write-HostHelix
    if ($Menu.DescriptionLines) {
        $Menu.DescriptionLines | % { Write-HostHelix $_ }
        Write-HostHelix
    }

    $Menu.Commands | % {
        Write-HostHelix "<" -NoNewline
        Write-Host $_.Command -ForegroundColor yellow -NoNewline
        Write-Host "> - $($_.Title)"
    }

    Write-HostHelix
    Write-HostHelix "> " -ForegroundColor yellow -NoNewline
    Read-Host
}

Function Pop-Menu {
    $null = $script:MenuStack.Pop()
}

Function Push-Menu([pscustomobject]$Menu) {
    if ($script:MenuStack.Count -gt 0) {
        $Menu.Commands += [pscustomobject]@{
            Command = "b"
            Title = "Go back"
            Script = {
                Pop-Menu
            }
        }
    }
    $Menu.Commands += [pscustomobject]@{
        Command = "q"
        Title = "Quit (or hit enter)"
        Script = {
            Exit
        }
    }

    $script:MenuStack.Push($Menu)
}

Function Write-Menu {
    do {
        $Menu = $script:MenuStack.Peek()
        $result = Print-Menu -Menu $Menu
        if ($result -eq '') {
            Exit
        }
        $command = $Menu.Commands | ? { $_.Command -eq $result } | select -first 1
        if (-not $command) {
            Write-HostHelix "Unknown command $result" -ForegroundColor Red
            Write-HostHelix
            Press-AnyKey
            continue
        }
        Write-HostHelix
        Write-HostHelix
        Invoke-Command $command.Script -ArgumentList $command.ScriptArgs
    } while ($script:MenuStack.Count -gt 0)
}


Export-ModuleMember Write-HostHelix
Export-ModuleMember Press-AnyKey
Export-ModuleMember Initialize-Menu
Export-ModuleMember Pop-Menu
Export-ModuleMember Push-Menu
Export-ModuleMember Write-Menu