# AIT Script
# by khemist
# 
# Requires -RunAsAdministrator
[CmdletBinding()]
param (
  [switch]$silent
)
function InfoHeader {
Clear-Host
Write-Output "-------------------------------------------------------------------------------------------"
Write-Output " AIT - Administration and Investigation Toolkit  v0.1 by Khemist"
Write-Output "-------------------------------------------------------------------------------------------"
Write-Output ""
Write-Output ""
}

# Navigate to user temp directory
Set-Location $env:temp

# Check if winget is installed & if it is, check if the version is at least v1.4
Write-Host "[*] Checking Winget version..." -ForegroundColor  green
if ((Get-AppxPackage -Name "*Microsoft.DesktopAppInstaller*") -and ((winget -v) -replace 'v','' -gt 1.4)) {
    $global:wingetInstalled = $true
}

else {
    $global:wingetInstalled = $false
    # Show warning that requires user confirmation, Suppress confirmation if Silent parameter was passed
    if (-not $Silent) {
        Write-Warning "Winget is not installed or outdated. This may prevent Win11Debloat from removing certain apps."
        Write-Output ""
        Write-Output "Press any key to continue anyway..."
        Read-Host | Out-Null
    }
}

# Show menu and wait for user input, loops until valid input is provided
function MainMenu {
        InfoHeader
        $Toolselectionmessege = "Please select an option (1-5 or 0)" 

        Write-Output "(1) Windows 10/11 tools"
        Write-Output "(2) Windows Server tools"
        Write-Output "(3) Network Tools"
        Write-Output "(4) DFIR Tools"
        Write-Output "(5) Windows Tweaks"
        Write-Output ""
        Write-Output "(0) Quit"
        Write-Output ""
        $Toolselectionmessege
}

function WindowsToolsMenu {
        InfoHeader
        $WinToolselectionmessege = "Please select an option (1-5 or 0)" 
    
        Write-Output "(1) Launch MAS Script"
        Write-Output "(2) Launch Windows 11 Debloat Script"
        Write-Output ""
        Write-Output "(0) Quit"
        $Wintoolselectionmessege
}

do {
    MainMenu
    $Tool = Read-Host
    switch ($Tool){
        '1'{
            clear
            do {
                WindowsToolsMenu
                $WindowsTool = Read-Host
                switch($WindowsTool){
                    '1'{
                        #Grabs and executes MAS Script
                        Write-Host "[*] Downloading MAS Script" -ForegroundColor Green
                        Invoke-RestMethod https://get.activated.win | Invoke-Expression
                    }
                }
            }
            until($WindowsTool -eq '0')
        }
    }
    pause    
    }
until ($Tool -eq '0')
