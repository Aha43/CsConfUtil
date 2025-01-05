# Makefile for SharpConfig (PowerShell-Compatible)

# Variables
PROJECT_NAME = SharpConfig
BUILD_DIR = SharpConfig/bin
ARTIFACTS_DIR = SharpConfig/artifacts
DOTNET = dotnet
NUGET_SOURCE = nuget.org
API_KEY_FILE = $(HOME)\\.nuget_api_key # Path to your NuGet API key file
VERSION = $(shell powershell -Command "(Select-String -Path $(PROJECT_NAME).csproj -Pattern '<Version>(.*?)</Version>' | ForEach-Object { $_.Matches.Groups[1].Value }).Trim()")

# Targets
.PHONY: all build test clean pack push help

# Default target
all: build test

# Build the project
build:
	@echo "Building the $(PROJECT_NAME)..."
	$(DOTNET) build -c Release

# Run tests
test:
	@echo "Running tests for $(PROJECT_NAME)..."
	$(DOTNET) test --logger:trx --results-directory $(BUILD_DIR)/TestResults

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	$(DOTNET) clean
	rm -rf $(BUILD_DIR) $(ARTIFACTS_DIR)

# Pack the NuGet package
pack:
	@echo "Packing the $(PROJECT_NAME) NuGet package..."
	$(DOTNET) pack -c Release --no-build -o $(ARTIFACTS_DIR)

# Push the NuGet package
push:
	@echo "Pushing the NuGet package to $(NUGET_SOURCE)..."
	@powershell -Command "$$apiKey = Get-Content $(API_KEY_FILE); $(DOTNET) nuget push $(ARTIFACTS_DIR)/$(PROJECT_NAME).$(VERSION).nupkg -s $(NUGET_SOURCE) -k $$apiKey"

# Git push (only if build and tests pass)
git-push: build test
	@echo "Pushing to Git repository..."
	git push

# Help target
help:
	@echo "Makefile for $(PROJECT_NAME)"
	@echo
	@echo "Targets:"
	@echo "  all       Build and test the project (default)"
	@echo "  build     Build the project"
	@echo "  test      Run unit tests"
	@echo "  clean     Clean build artifacts"
	@echo "  pack      Create a NuGet package"
	@echo "  push      Push the NuGet package to nuget.org"
	@echo "  git-push  Push to Git repository (only if build and tests pass)"
	@echo "  help      Show this help message"
