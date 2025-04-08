# 
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

function Install-CustomModules {
  param (
    [string]$ModuleName = ''
  )
  # check if module is installed
  $moduleInfo = Get-Module -ListAvailable -Name $ModuleName -ErrorAction SilentlyContinue
  if (-not $moduleInfo) {
    Write-Host "${ModuleName} module not found." -ForegroundColor Red
    Install-Module -Name $ModuleName -Scope CurrentUser
  }
  Import-Module -Name $ModuleName
}

Install-CustomModules -ModuleName 'tiPS'
Install-CustomModules -ModuleName 'PSScriptAnalyzer'
Install-CustomModules -ModuleName 'Terminal-Icons'
Install-CustomModules -ModuleName 'PSReadLine'
Install-CustomModules -ModuleName 'PSWindowsUpdate'

# kali.omp.json
oh-my-posh --init --shell pwsh --config "$env:OneDrive\Documents\PowerShell\prompt\themes\stelbent-compact.minimal.omp.json" | Invoke-Expression

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineKeyHandler -Key Tab -Function Complete

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}
function Get-Ip-Address {
  (Invoke-WebRequest -Uri ifconfig.me/ip).Content
}

Set-Alias getIp Get-Ip-Address

function Invoke-WslReboot() {
  param (
    [string]$Distro = 'Debian'
  )
  Write-Host "Rebooting $Distro"
  wsl --shutdown
}

Set-Alias wslreboot Invoke-WslReboot

function Update-Budget() {
  Write-Host "Updating budget database"
  py D:\dev\export-budget-csv\export.py -s "$env:OneDrive\Documents\Financial\Wood Family Financials.xlsx"
  Write-Host "Budget database updated"
}

Set-Alias updbudget Update-Budget

function Update-Winget() {
  winget upgrade
}

Set-Alias wgu Update-Winget
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
else {
  Write-Host "zoxide command not found. Attempting to install via winget..."
  try {
    winget install -e --id ajeetdsouza.zoxide
    Write-Host "zoxide installed successfully. Initializing..."
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
  }
  catch {
    Write-Error "Failed to install zoxide. Error: $_"
  }
}

Set-TiPSConfiguration -AutomaticallyWritePowerShellTip EverySession

# Finds files recursively matching a pattern.
function ff($name) {
  Get-ChildItem -Recurse -Filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object { Write-Output "${$_.directory}\$(%_)" }
}

# Creates an empty file (similar to the touch command in Linux).
function touch($file) {
  "" | Out-File -File $file -Encoding ascii
}

# Reloads the current profile.
function Update-Profile {
  & $PROFILE
}

# Checks for and updates PowerShell to the latest version.
function Update-PowerShell {
  if (-not $global:canConnectToGitHub) {
    Write-Host "Skipping PowerShell update check due to GitHub.com not responding within 1 second." -ForegroundColor Yellow
    return
  }

  try {
    Write-Host "Checking for PowerShell updates..." -ForegroundColor Cyan
    $updateNeeded = $false
    $currentVersion = $PSVersionTable.PSVersion.ToString()
    $gitHubApiUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
    $latestReleaseInfo = Invoke-RestMethod -Uri $gitHubApiUrl
    $latestVersion = $latestReleaseInfo.tag_name.Trim('v')
    if ($currentVersion -lt $latestVersion) {
      $updateNeeded = $true
    }

    if ($updateNeeded) {
      Write-Host "Updating PowerShell..." -ForegroundColor Yellow
      winget upgrade "Microsoft.PowerShell" --accept-source-agreements --accept-package-agreements
      Write-Host "PowerShell has been updated. Please restart your shell to reflect changes" -ForegroundColor Magenta
    }
    else {
      Write-Host "Your PowerShell is up to date." -ForegroundColor Green
    }
  }
  catch {
    Write-Error "Failed to update PowerShell. Error: $_"
  }
}
Update-PowerShell

# Searches for a regular expression in files (similar to the grep command in Linux).
function grep($regex, $dir) {
  if ( $dir ) {
    Get-ChildItem $dir | select-string $regex
    return
  }
  $input | select-string $regex
}

# Displays disk volume information.
function df {
  get-volume
}

# Displays the first n lines of a file8587
function head {
  param($Path, $n = 10)
  Get-Content $Path -Head $n
}

# Displays the last n lines of a file 
function tail {
  param($Path, $n = 10)
  Get-Content $Path -Tail $n
}

# Navigates to the Documents directory.
function docs { Set-Location -Path $HOME\Documents }

# Navigates to the Downloads directory.
function dl { Set-Location -Path $HOME\Downloads }

# Clears the DNS client cache.
function flushdns { Clear-DnsClientCache }

# Copies text to the clipboard.
function cpy { Set-Clipboard $args[0] }

# Gets the text from the clipboard.
function pst { Get-Clipboard }

# Enhanced PowerShell Experience
Set-PSReadLineOption -Colors @{
  Command   = 'Yellow'
  Parameter = 'Green'
  String    = 'DarkCyan'
}

# http://bin.christitus.com/unakijolon