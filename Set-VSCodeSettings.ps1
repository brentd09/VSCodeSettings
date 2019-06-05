[CmdletBinding()]
Param()
if (Test-Path -Path "C:\Program files\Microsoft VS Code\Code.exe") {
  if (-not (Test-Path "$env:APPDATA\Code\User\")) {
    & "C:\Program files\Microsoft VS Code\Code.exe"
    Start-Sleep 5
    Get-Process | Where-Object path -match 'code.exe$' | Stop-Process 
  }
  # attempting to copy my UserSettings and Snippets into VSCode
  if (Test-Path .\settings.json) {
    try {
      Copy-Item .\settings.json $env:APPDATA\Code\User\ -ErrorAction stop
      Copy-Item .\keybindings.json $env:APPDATA\Code\User\ -ErrorAction stop
      Copy-Item .\powershell.json $env:APPDATA\Code\User\snippets\ -ErrorAction Stop
    }
    catch {Write-Warning "File copy did not work"}
  }
  else {
    try {
      $drives = (Get-PSDrive -PSProvider filesystem | Where-Object {$_.used -and -not $_.displayroot}).Root
      $Location = Get-ChildItem -Path $drives -Filter set-vscodesettings.ps1 -Recurse -ErrorAction SilentlyContinue
      $Directory = $Location.Directory.FullName
      Copy-Item $Directory\settings.json $env:APPDATA\Code\User\ -ErrorAction stop
      Copy-Item $Directory\keybindings.json $env:APPDATA\Code\User\ -ErrorAction stop
      Copy-Item $Directory\powershell.json $env:APPDATA\Code\User\snippets\ -ErrorAction Stop
    }
    catch {Write-Warning "File copy did not work"}
  }
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