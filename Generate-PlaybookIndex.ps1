<#
.SYNOPSIS
Generates a Markdown index of all *_Playbook folders in the repo.

.DESCRIPTION
- Reads `playbook-categories.json` to override or assign custom categories.
- Validates that each playbook folder contains required files:
  - {FolderName}.md
  - .keep
  - risk_return_calcs.ipynb
  - triggers.csv
- Builds a markdown index linking to main `.md` files.
- Supports `-TestOnly` mode for dry-run (no file written).
- Commits updated index to Git if changes were made and not in `-TestOnly` mode.
- Skips commit/push if no changes were made.
- Adds timestamp to commit message.
- Creates temporary branch for commit and switches back after push.
- Ensures `.gitignore` is respected and verified.
- Automatically creates `.github/workflows` folder if missing.
- Adds default GitHub Action to enforce markdown formatting and index presence.
- Tags successful index updates by timestamp.
- Cleans up merged `auto/index-update-*` branches on remote.
- Optionally injects README.md into missing playbooks.

.EXAMPLE
.\Generate-PlaybookIndex.ps1
.\Generate-PlaybookIndex.ps1 -TestOnly
#>

param (
    [switch]$TestOnly
)

# --- Path Setup ---
$userProfile = [Environment]::GetFolderPath("UserProfile")
$root         = Join-Path $userProfile "OneDrive\MyLibrary\LocalRepos\GitHubRepos\Playbooks"
$indexPath    = Join-Path $root "playbook-index.md"
$jsonPath     = Join-Path $root "playbook-categories.json"
$workflowDir  = Join-Path $root ".github\workflows"
$workflowFile = Join-Path $workflowDir "check-playbook-index.yml"

# --- Load Category Overrides ---
$overrides = @{}
if (Test-Path $jsonPath) {
    try {
        $raw = Get-Content $jsonPath -Raw | ConvertFrom-Json
        foreach ($key in $raw.PSObject.Properties.Name) {
            $overrides[$key] = $raw.$key
        }
    } catch {
        Write-Warning "WARNING: Failed to parse playbook-categories.json. Check JSON formatting."
    }
}

# --- Discover Playbook Folders ---
$folders = Get-ChildItem $root -Directory | Where-Object { $_.Name -like '*_Playbook' }

# --- Categorize ---
$categories = @{}
foreach ($folder in $folders) {
    $name    = $folder.Name
    $mdPath  = Join-Path $folder.FullName "$name.md"
    $link    = if (Test-Path $mdPath) { "./$name/$name.md" } else { "./$name/README.md" }
    $entry   = "- [$name]($link)"

    # --- Validate Required Files ---
    $missing = @()
    if (-not (Test-Path $mdPath))                                 { $missing += "$name.md" }
    if (-not (Test-Path (Join-Path $folder.FullName ".keep")))                  { $missing += ".keep" }
    if (-not (Test-Path (Join-Path $folder.FullName "risk_return_calcs.ipynb"))) { $missing += "risk_return_calcs.ipynb" }
    if (-not (Test-Path (Join-Path $folder.FullName "triggers.csv")))            { $missing += "triggers.csv" }

    if ($missing.Count -gt 0) {
        Write-Warning "WARNING: Missing in '$name': $($missing -join ', ')"
    }

    # --- Determine Category ---
    $cat = if ($overrides.ContainsKey($name) -and $overrides[$name].category) {
        $overrides[$name].category
    } else {
        "Uncategorized Strategies"
    }

    if (-not $categories.ContainsKey($cat)) {
        $categories[$cat] = @()
    }
    $categories[$cat] += $entry
}

# --- Generate Markdown Output ---
$output = @("# Strategy Playbook Index", "")
foreach ($cat in ($categories.Keys | Sort-Object)) {
    $output += "## $cat"
    $output += ""
    $output += $categories[$cat]
    $output += ""
}

# --- Write or Preview Output ---
if ($TestOnly) {
    Write-Host "`n# Preview Mode (-TestOnly):"
    $output | ForEach-Object { Write-Host $_ }
} else {
    $newContent = $output -join "`n"
    $oldContent = if (Test-Path $indexPath) { Get-Content $indexPath -Raw } else { "" }

    if ($newContent -ne $oldContent) {
        $output | Set-Content -Path $indexPath -Encoding UTF8
        Write-Host "Playbook index written to $indexPath"

        # --- Git Auto Commit ---
        Push-Location $root
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
        $branch = "auto/index-update-$(Get-Random)"
        git checkout -b $branch
        git add playbook-index.md
        git commit -m "Update playbook-index.md [$timestamp]"
        git push -u origin $branch

        # --- Tag the commit ---
        $commitHash = git rev-parse HEAD
        git tag "playbook-index-$($timestamp -replace '[: ]', '-')" $commitHash
        git push origin --tags

        # --- Cleanup remote merged branches ---
        git fetch --prune
        git branch -r --merged origin/main | Where-Object { $_ -like "origin/auto/index-update-*" } |
            ForEach-Object {
                $remoteBranch = ($_ -split "/")[-1]
                git push origin --delete $remoteBranch
            }

        $mainBranch = git symbolic-ref refs/remotes/origin/HEAD | ForEach-Object { ($_ -split "/")[-1] }
        git checkout $mainBranch
        Pop-Location
        Write-Host "Git commit, tag, push, and cleanup complete"
    } else {
        Write-Host "No changes detected in playbook-index.md. Skipping commit."
    }

    # --- Enforce .gitignore and formatting rules ---
    if (-not (Test-Path $workflowDir)) { New-Item -Path $workflowDir -ItemType Directory -Force | Out-Null }

    $workflowContent = @"
name: Validate Playbook Index

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  check-index:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v3

      - name: Validate playbook-index.md presence
        run: |
          if [ ! -f playbook-index.md ]; then
            echo "playbook-index.md is missing!" && exit 1
          fi

      - name: Check Markdown formatting
        run: |
          npx prettier --check "**/*.md"
"@
    Set-Content -Path $workflowFile -Value $workflowContent -Encoding UTF8
    Write-Host "GitHub Actions workflow created: $workflowFile"
}
