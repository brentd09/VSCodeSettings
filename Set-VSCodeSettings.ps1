[CmdletBinding()]
Param()
if (-not (Test-Path "$env:APPDATA\Code\User\")) {
  & "C:\Program files\Microsoft VS Code\Code.exe"
  Start-Sleep 1
  Get-Process | Where-Object path -match 'code.exe$' | Stop-Process 
}
# attempting to copy my UserSettings and Snippets into VSCode
try {
  Copy-Item .\settings.json $env:APPDATA\Code\User\ -ErrorAction stop
  Copy-Item .\powershell.json $env:APPDATA\Code\User\snippets\ -ErrorAction Stop
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
