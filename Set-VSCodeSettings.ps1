[CmdletBinding()]
Param()
if (-not (Test-Path "$env:APPDATA\Code\User\")) {
  & "C:\Program files\Microsoft VS Code\Code.exe"
  Start-Sleep 1
  Get-Process | Where-Object path -match 'code.exe$' | Stop-Process 
}
try {Copy-Item ./settings.json $env:APPDATA\Code\User\}
catch {Write-Warning "File copy did not work"}
