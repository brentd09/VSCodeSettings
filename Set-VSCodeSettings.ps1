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
