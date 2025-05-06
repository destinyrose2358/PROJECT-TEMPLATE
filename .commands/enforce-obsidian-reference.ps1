# Get the script's current path (inside .commands)
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath -Parent

# Assume parent of .commands is the project folder
$projectPath = Split-Path $scriptDir -Parent
$projectName = Split-Path $projectPath -Leaf

$vaultName = "$projectName documents"
$vaultPath = Join-Path $projectPath $vaultName

# Path to obsidian.json
$obsidianConfigPath = Join-Path $env:APPDATA "Obsidian\obsidian.json"

if (-Not (Test-Path $obsidianConfigPath)) {
    Write-Error "obsidian.json not found at $obsidianConfigPath"
    exit 1
}

# Load obsidian.json
$json = Get-Content $obsidianConfigPath -Raw | ConvertFrom-Json

# Ensure vaults property exists
if (-not $json.vaults) {
    $json | Add-Member -NotePropertyName 'vaults' -NotePropertyValue @{}
}

$vaults = $json.vaults

# Mark other vaults as closed (efficient search)
$previouslyOpen = $vaults.PSObject.Properties |
    Where-Object { $_.Value.open -eq $true -and $_.Name -ne $projectVaultKey } |
    Select-Object -First 1

if ($previouslyOpen) {
    $vaults.$($previouslyOpen.Name).open = $false
}

# Try to find an existing vault by matching the "path" value
$matchingVault = $vaults.PSObject.Properties |
    Where-Object { $_.Value.path -eq $vaultPath } |
    Select-Object -First 1

# If found, reuse its key; otherwise, use the full path as the new key
if ($matchingVault) {
    $vaultKey = $matchingVault.Name
    $vaults.$vaultKey.open = $true
} else {
    $vaultKey = "$($vaultName)_$(Get-Date -Format 'yyyyMMddHHmmss')"
    $vaults | Add-Member -NotePropertyName $vaultKey -NotePropertyValue @{
        path = $vaultPath
        ts = [int][double]::Parse((Get-Date -UFormat %s))
        open = $true
    }
}

# Save back to obsidian.json
$config = [PSCustomObject]@{ vaults = $vaults }
$jsonString = $config | ConvertTo-Json -Depth 10
$utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($false)
$writer = New-Object System.IO.StreamWriter($obsidianConfigPath, $false, $utf8NoBomEncoding)
$writer.Write($jsonString)
$writer.Close()

Write-Host "Vault '$vaultName' at '$projectPath' is now marked open (vault key:$vaultKey)."
# $null = Read-Host
