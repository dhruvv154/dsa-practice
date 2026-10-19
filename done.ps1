# Usage: .\done.ps1 "Two Sum: hashmap O(n)"
param([Parameter(Mandatory)][string]$Message)

Set-Location $PSScriptRoot
git add -A
git commit -m $Message
if ($?) { git push }
