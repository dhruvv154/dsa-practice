# Usage: .\new.ps1 <topic-folder> <number-slug> [ext]
# Example: .\new.ps1 arrays-hashing 0001-two-sum
param(
    [Parameter(Mandatory)][string]$Topic,
    [Parameter(Mandatory)][string]$Name,
    [string]$Ext = "py"
)

$dir = Join-Path $PSScriptRoot $Topic
if (-not (Test-Path $dir)) { Write-Error "No topic folder '$Topic'"; exit 1 }

$file = Join-Path $dir "$Name.$Ext"
if (Test-Path $file) { Write-Error "$file already exists"; exit 1 }

Copy-Item (Join-Path $PSScriptRoot "TEMPLATE.py") $file
Write-Host "Created $file"
