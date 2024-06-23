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

$computername = hostname

# Show menu and wait for user input, loops until valid input is provided
function MainMenu {
        InfoHeader
        $Toolselectionmessege = "Please select an option" 

        Write-Output "(1) Windows 10/11 tools"
        Write-Output "(2) Windows Server tools"
        Write-Output "(3) Network Tools"
        Write-Output "(4) DFIR Tools"
        Write-Output "(5) Windows Tweaks"
        Write-Output ""
        Write-Output "(q) Quit"
        Write-Output ""
        $Toolselectionmessege
}

function WinToolsMenu {
        InfoHeader
        Write-Output "(1) Install .Net 4.0"
        Write-Output "(2) Enable Bitlocker"
	Write-Output ""
        Write-Output "(0) Return to Main Menu"
	Write-Output "(q) Quit"
}

function WindowsTweaksMenu {
        InfoHeader 
    
        Write-Output "(1) Launch MAS Script"
        Write-Output "(2) Launch Windows 11 Debloat Script"
        Write-Output ""
        Write-Output "(0) Return to Main Menu"
        Write-Output "(Q) Quit"
        $Toolselectionmessege
}

#Windows Tools
function DotNet3 {
    #Enables .Net 3.5
    Write-Host "[*] Enabling .Net 3.5" -ForegroundColor Green
    DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
    Write-Host "[*] .Net 3.5 Enabled"
}

function Bitlocker {
    #Checks if Bitlocker enabled, if not, enables and prints recovery password to file
    if (((Get-BitLockerVolume -MountPoint c:).VolumeStatus) -eq 'FullyEncrypted') {
        Write-Host "[*] Bitlocker is already enabled for Drive C:"
    }
    else {
        Enable-Bitlocker -MountPoint C -UsedSpaceOnly -RecoveryPassword
    }
    $Bitlockerkey = (Get-BitLockerVolume -MountPoint C).KeyProtector | Where-Object -Property KeyProtectorType -eq RecoveryPassword | Select-Object -Property KeyProtectorID,RecoveryPassword 
    $Bitlockerkey > "$HOME\$computername.txt"
    Write-Output "Bitlocker enabled. Bitlocker key is saved to $HOME\$computername.txt"
    Write-Output "$Bitlockerkey"
}

# Windows Tweaks
function MASscript {
    #Grabs and executes MAS Script
    Write-Host "[*] Downloading MAS Script" -ForegroundColor Green
    Invoke-RestMethod https://get.activated.win | Invoke-Expression
}

function Win11DebloatScript {
    #Grabs and executes Windows 11 debloat script
     & ([scriptblock]::Create((irm "https://raw.githubusercontent.com/Raphire/Win11Debloat/master/Get.ps1")))
}

do {
    MainMenu
    $Tool = Read-Host
    switch ($Tool){
        '1'{
            clear
            do {
                WinToolsMenu
                $WindowsTool = Read-Host
                switch($WindowsTool){
                    '1'{
                        DotNet3
                    }
                    '2'{
                        Bitlocker
                    }
                }
		
            }
	        until($WindowsTool -eq 'q')
		    MainMenu
        }
        '5'{
            clear
            do {
                WindowsTweaksMenu
                $WinTweak = Read-Host
                switch($WinTweak){
                    '1'{
                       MASscript
                    }
                    '2'{
                       Win11DebloatScript 
                    }
		    '0'{
                        MainMenu
                    }
                }
            }
            until($WinTweak -eq 'q')
            
        }
    }
    pause    
    }
until ($Tool -eq 'q')
Set-Location $HOME
exit
