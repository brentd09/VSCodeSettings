[CmdletBinding()]
Param()
$VSCODEInstalled = $false 
if (Test-Path -Path "C:\Program files\Microsoft VS Code\Code.exe") {
  $VSCodeExePath = "C:\Program files\Microsoft VS Code\Code.exe"
  $VSCODEInstalled = $true
}
elseif (Test-Path -Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe") {
  $VSCodeExePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
  $VSCODEInstalled = $true
}
if ($VSCODEInstalled -eq $true) {
  if (-not (Test-Path "$env:APPDATA\Code\User\")) {
    & $VSCodeExePath
    Start-Sleep 5
    Get-Process | Where-Object path -match 'code.exe$' | Stop-Process 
  }
  # attempting to copy my UserSettings and Snippets into VSCode
  $ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition
  try {
    New-Item -Path $env:APPDATA\Code\User -Name snippets -ItemType Directory -Force -ErrorAction stop *> $null
    Copy-Item $ScriptPath\settings.json $env:APPDATA\Code\User\ -Force -ErrorAction stop
    Copy-Item $ScriptPath\keybindings.json $env:APPDATA\Code\User\ -Force -ErrorAction stop
    Copy-Item $ScriptPath\powershell.json $env:APPDATA\Code\User\snippets\ -Recurse -Force -ErrorAction Stop
  }
  catch {Write-Warning "File copy did not work"}
  $GitConfig = git config --list | Where-Object {$_ -match 'user\.name'}
  if ($GitConfig -notmatch 'user\.name\=Brent Denny') {
    try {
      Invoke-Command -ScriptBlock {git config --global user.name "Brent Denny"} -ErrorAction Stop
      Invoke-Command -ScriptBlock {git config --global user.email "brent.denny@ddls.com.au"} -ErrorAction Stop
    }
    catch {
      Write-Warning 'The git command did not work'
    }
  }
}
else {write-warning "Install VSCode first"}