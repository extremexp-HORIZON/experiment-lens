$Org = "extremexp-HORIZON"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$ReposDir = Join-Path $Root "repos"

$Targets = @(
    @{ Name = "vis-frontend"; Branch = "new-extreme-new-navigation" }
    @{ Name = "vis-api"; Branch = "zenoh-integration" }
    @{ Name = "extremexp-explainability-module"; Branch = "main" }
)

if (-not (Test-Path $ReposDir)) {
    New-Item -ItemType Directory -Path $ReposDir | Out-Null
}

Write-Host "Updating/cloning repositories..."

foreach ($t in $Targets) {
    $Repo = $t.Name
    $Branch = $t.Branch
    $LocalPath = Join-Path $ReposDir $Repo

    if (Test-Path "$LocalPath/.git") {
        Write-Host "➡ Updating $Repo (branch $Branch)..."
        Set-Location $LocalPath
        git fetch origin
        git checkout $Branch
        git pull --rebase origin $Branch
        Set-Location $Root
    }
    else {
        Write-Host "⬇ Cloning $Repo (branch $Branch)..."
        git clone --branch $Branch "https://github.com/$Org/$Repo.git" $LocalPath
    }
}

Write-Host "All repositories ready at $ReposDir"
