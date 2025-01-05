# Makefile for SharpConfig

# Variables
PROJECT_NAME = SharpConfig
BUILD_DIR = bin
TEST_RESULTS_DIR = TestResults
DOTNET = dotnet

# Targets
.PHONY: all build test clean help

# Default target
all: build test

# Build the project
build:
	@echo "Building the $(PROJECT_NAME)..."
	$(DOTNET) build

# Run tests
test:
	@echo "Running tests for $(PROJECT_NAME)..."
	$(DOTNET) test --logger:trx --results-directory $(TEST_RESULTS_DIR)

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	$(DOTNET) clean
	rm -rf $(BUILD_DIR) $(TEST_RESULTS_DIR)

# Help target
help:
	@echo "Makefile for $(PROJECT_NAME)"
	@echo
	@echo "Targets:"
	@echo "  all       Build and test the project (default)"
	@echo "  build     Build the project"
	@echo "  test      Run unit tests"
	@echo "  clean     Clean build artifacts"
	@echo "  help      Show this help message"
