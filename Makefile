# Makefile for .NET C# Class Library Project

# Project settings
PROJECT_NAME = CsConfUtil
SOLUTION_FILE = $(PROJECT_NAME).sln
PROJECT_FILE = src/$(PROJECT_NAME)/$(PROJECT_NAME).csproj
OUTPUT_DIR = bin/Release
NUGET_PACKAGE = $(OUTPUT_DIR)/$(PROJECT_NAME).nupkg

# Default target: Build
all: build

# Restore NuGet packages
restore:
	dotnet restore $(SOLUTION_FILE)

# Build the project
build: restore
	dotnet build $(SOLUTION_FILE) --configuration Release

# Run tests
test:
	dotnet test --configuration Release --verbosity normal

# Clean the build
clean:
	dotnet clean
	rm -rf $(OUTPUT_DIR)

# Create a NuGet package
pack: build
	dotnet pack $(PROJECT_FILE) --configuration Release --output $(OUTPUT_DIR)

# Format the code
format:
	dotnet format

# Create and push a new tag
tag:
	git tag $(TAG)
	git push origin $(TAG)

# Delete a tag (both locally and remotely) and re-tag the latest commit
retag:
	git tag -d $(TAG)
	git push origin --delete $(TAG) || true
	git tag $(TAG)
	git push origin $(TAG)

# Retag and push again, ensuring it always points to the latest commit
retag-latest:
	git tag -d $(TAG) || true
	git push origin --delete $(TAG) || true
	git tag $(TAG) HEAD
	git push origin $(TAG)

# List all available targets
help:
	@echo "Available targets:"
	@echo "  make all       					- Build the project (default)"
	@echo "  make restore   					- Restore NuGet packages"
	@echo "  make build     					- Build the project in Release mode"
	@echo "  make test      					- Run unit tests"
	@echo "  make clean     					- Clean the project"
	@echo "  make pack      					- Create a NuGet package"
	@echo "  make format    					- Format the code"
	@echo "  make tag TAG=vX.Y.Z        		- Create and push a new tag"
	@echo "  make retag TAG=vX.Y.Z-test 		- Delete and re-tag the latest commit (re-run workflows)"
	@echo "  make retag-latest TAG=vX.Y.Z-test 	- Move tag to the latest commit and push again"
	@echo "  make help      					- Show available targets"

.PHONY: all restore build test clean pack format tag retag retag-latest help
