# Path Setup
$root = "C:\Users\Trader\OneDrive\MyLibrary\LocalRepos\GitHubRepos\Playbooks"
$indexPath = Join-Path $root "playbook-index.md"
$jsonPath = Join-Path $root "playbook-categories.json"

# Load category overrides as hashtable
$overrides = @{}
if (Test-Path $jsonPath) {
    $raw = Get-Content $jsonPath -Raw | ConvertFrom-Json
    foreach ($key in $raw.PSObject.Properties.Name) {
        $overrides[$key] = $raw.$key
    }
}

# Get all playbook folders
$folders = Get-ChildItem $root -Directory | Where-Object { $_.Name -like '*_Playbook' }

# Categorize
$categories = @{}
foreach ($folder in $folders) {
    $name = $folder.Name
    $entry = "- [`$name`](./$name/README.md)"

    if ($overrides.ContainsKey($name) -and $overrides[$name].category) {
        $cat = $overrides[$name].category
    } else {
        $cat = "Uncategorized Strategies"
    }

    if (-not $categories.ContainsKey($cat)) {
        $categories[$cat] = @()
    }
    $categories[$cat] += $entry
}

# Generate index file
$output = @("# 📘 Strategy Playbook Index", "")
foreach ($cat in ($categories.Keys | Sort-Object)) {
    $output += "## 🗂 $cat"
    $output += ""
    $output += $categories[$cat]
    $output += ""
}
$output | Set-Content -Path $indexPath -Encoding UTF8

Write-Host "✅ playbook-index.md generated at $indexPath"
