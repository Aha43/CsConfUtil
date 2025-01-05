# build.ps1: PowerShell script for automating DevOps tasks for SharpConfig

param(
    [string]$Task = "help"
)

# Define paths and variables
$ProjectName = "SharpConfig"
$ProjectFile = "./$ProjectName/$ProjectName.csproj"
$BuildDir = "./$ProjectName/$ProjectName/bin"
$ArtifactsDir = "./$ProjectName/artifacts"
$LocalRepo = "$HOME/.nuget-local"
$NugetSource = "nuget.org"
$ApiKeyFile = "$HOME/.nuget_api_key"
$Version = (Select-String -Path $ProjectFile -Pattern '<Version>(.*?)</Version>' | ForEach-Object { $_.Matches.Groups[1].Value }).Trim()

# Helper function: Ensure a directory exists
function Ensure-Directory {
    param ([string]$Path)
    if (-not (Test-Path -Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

# Helper function: Display help
function Show-Help {
    Write-Host "Available tasks for SharpConfig:"
    Write-Host "  build             Build the project (release)"
    Write-Host "  test              Run unit tests"
    Write-Host "  clean             Clean build artifacts"
    Write-Host "  pack              Create a NuGet package"
    Write-Host "  publish-local     Publish the NuGet package to local repository"
    Write-Host "  publish-nuget-org Push the NuGet package to nuget.org"
    Write-Host "  git-push          Push to Git repository (only if build and tests pass)"
    Write-Host "  help              Show this help message"
}

# Task: Build the project
function Build-Project-For-Task {
    Write-Host "Building the project..."
    dotnet build -c Release
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build failed. Stopping further execution."
        exit 1
    }
}

# Task: Run tests
function Run-Tests-For-Task {
    Write-Host "Running tests..."
    dotnet test --logger:trx --results-directory "$BuildDir/TestResults"
    if ($LASTEXITCODE -ne 0) { 
        Write-Error "Tests failed. Stopping further execution."
        exit 1
    }
}

# Task: Clean build artifacts
function Clean-Project {
    Write-Host "Cleaning build artifacts..."
    Remove-Item -Recurse -Force $BuildDir, $ArtifactsDir -ErrorAction SilentlyContinue
    dotnet clean
}

# Task: Pack NuGet package
function Pack-Package {
    Write-Host "Packing NuGet package (version $Version)..."
    Ensure-Directory -Path $ArtifactsDir
    dotnet pack -c Release --no-build -o $ArtifactsDir
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Packaging failed. Stopping further execution."
        exit 1
    }
}

# Task: Publish package to local repository
function Publish-Local {
    Pack-Package
    Write-Host "Publishing package to local repository (version $Version)..."
    Ensure-Directory -Path $LocalRepo
    Copy-Item "$ArtifactsDir/$ProjectName.$Version.nupkg" -Destination $LocalRepo
    dotnet nuget add source $LocalRepo --name local-repo || Write-Host "Local repository already exists."
}

# Task: Publish package to NuGet.org
function Publish-Nuget-Org {
    Pack-Package
    Write-Host "Publishing to NuGet.org (version $Version)..."
    if (-not (Test-Path -Path $ApiKeyFile)) {
        Write-Error "API key file not found at $ApiKeyFile."
        exit 1
    }
    $ApiKey = Get-Content $ApiKeyFile -Raw
    if (-not (dotnet nuget push "$ArtifactsDir/$ProjectName.$Version.nupkg" `
              -s $NugetSource `
              -k $ApiKey)) {
        Write-Error "Publishing to NuGet.org failed. Stopping further execution."
        exit 1
    }
}

# Task: Git push (only if build and tests pass)
function Git-Push {
    Write-Host "Running pre-push checks..."
    Build-Project-For-Task
    Run-Tests-For-Task
    Write-Host "Pre-push checks passed. Pushing to Git repository..."
    git push
}

# Run the selected task
switch ($Task) {
    "build" { dotnet build -c Release }
    "test" { dotnet test }
    "clean" { Clean-Project }
    "pack" { Pack-Package }
    "publish-local" { Publish-Local }
    "publish-nuget-org" { Publish-Nuget-Org }
    "git-push" { Git-Push }
    "help" { Show-Help }
    default {
        Write-Host "Unknown task: $Task"
        Show-Help
    }
}
