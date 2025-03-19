if (-not (Get-Module -ListAvailable -Name tiPS)) {
  Install-Module -Name tiPS -Scope CurrentUser
}
if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
  Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser
}
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
  Install-Module -Name Terminal-Icons -Scope CurrentUser
}
if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
  Install-Module -Name PSReadLine -Force -Scope CurrentUser
}


if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
  Import-Module -Name Terminal-Icons
}
if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
  Import-Module -Name PSReadLine
}

# kali.omp.json
oh-my-posh --init --shell pwsh --config "$env:OneDrive\Documents\PowerShell\prompt\themes\easy-term.omp.json" | Invoke-Expression

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
    [string]$Distro = 'Ubuntu'
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

function ff($name) {
  Get-ChildItem -Recurse -Filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object { Write-Output "${$_.directory}\$(%_)" }
}

function touch($file) {
  "" | Out-File -File $file -Encoding ascii
}

function reload-profile {
  & $PROFILE
}


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

function grep($regex, $dir) {
  if ( $dir ) {
    Get-ChildItem $dir | select-string $regex
    return
  }
  $input | select-string $regex
}

function df {
  get-volume
}

function head {
  param($Path, $n = 10)
  Get-Content $Path -Head $n
}

function tail {
  param($Path, $n = 10)
  Get-Content $Path -Tail $n
}

function docs { Set-Location -Path $HOME\Documents }

# Networking Utilities
function flushdns { Clear-DnsClientCache }

# Clipboard Utilities
function cpy { Set-Clipboard $args[0] }

function pst { Get-Clipboard }

# Enhanced PowerShell Experience
Set-PSReadLineOption -Colors @{
  Command   = 'Yellow'
  Parameter = 'Green'
  String    = 'DarkCyan'
}

# http://bin.christitus.com/unakijolon