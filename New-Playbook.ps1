param (
    [Parameter(Mandatory = $true)]
    [string]$Name
)

# Path setup
$rootPath = "C:\Users\Trader\OneDrive\MyLibrary\LocalRepos\GitHubRepos\Playbooks"
$templatePath = Join-Path $rootPath "_Template_Playbook"
$newPlaybookPath = Join-Path $rootPath ("${Name}_Playbook")
$topLevelReadme = Join-Path $rootPath "README.md"

# Prevent overwrite
if (Test-Path $newPlaybookPath) {
    Write-Host "❌ ERROR: Folder already exists: $newPlaybookPath" -ForegroundColor Red
    exit 1
}

# Copy template folder
Copy-Item -Path $templatePath -Destination $newPlaybookPath -Recurse

# Personalize new README
$playbookReadme = Join-Path $newPlaybookPath "README.md"
(Get-Content $playbookReadme) -replace '\[Strategy Name\]', $Name | Set-Content $playbookReadme

# Add to top-level README.md
$entry = "- [`${Name}_Playbook`](./${Name}_Playbook/README.md): Playbook for the ${Name} strategy."

# Read and split README
$readmeLines = Get-Content $topLevelReadme
$insertPoint = ($readmeLines | Select-String '## 📂 Current Playbooks').LineNumber

if ($insertPoint -eq $null) {
    Write-Host "⚠️ Could not find '## 📂 Current Playbooks' in README.md." -ForegroundColor Yellow
    exit 1
}

$top = $readmeLines[0..$insertPoint]
$bottom = $readmeLines[($insertPoint + 1)..($readmeLines.Count - 1)]
$newLines = $top + $entry + $bottom

# Write back to README
$newLines | Set-Content $topLevelReadme

Write-Host "✅ Created new playbook: ${Name}_Playbook and registered it in README.md" -ForegroundColor Green
