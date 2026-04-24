# ============================================
# SciTeX Template Research - Makefile
# ============================================
# Scientific research project workflow automation
# Location: /Makefile
#
# Key Features:
# - Script execution and pipeline management
# - Dependency installation and environment setup
# - Output cleaning and data management
# - Code formatting and quality checks
# - Testing automation
#
# Usage:
#   make help                      # Show this help
#   make install                   # Install dependencies
#   make run-mnist                 # Run MNIST example pipeline
#   make clean                     # Clean outputs
#   make format                    # Format code
#   make test                      # Run tests

.PHONY: \
	help \
	install \
	install-dev \
	setup \
	setup-writer \
	run-mnist \
	run-mnist-download \
	run-mnist-plot-digits \
	run-mnist-plot-umap \
	run-mnist-clf-svm \
	run-mnist-conf-mat \
	clean \
	clean-mnist \
	clean-outputs \
	clean-data \
	clean-logs \
	clean-all \
	clean-python \
	clean-writer \
	test \
	test-verbose \
	test-sync \
	format \
	format-python \
	format-shell \
	lint \
	lint-python \
	check \
	info \
	tree \
	verify \
	show-config

.DEFAULT_GOAL := help

# ============================================
# Configuration
# ============================================
PYTHON := python3
PIP := pip3
SCRIPTS_DIR := scripts
MNIST_DIR := $(SCRIPTS_DIR)/mnist
CONFIG_DIR := config
DATA_DIR := data
TESTS_DIR := tests
SCITEX_DIR := scitex
WRITER_DIR := $(SCITEX_DIR)/writer  # ./scitex/writer/01_manuscript/...
MGMT_SCRIPTS := management/scripts

# ============================================
# Help
# ============================================
help:
	@echo ""
	@echo "############################################################"
	@echo "#      SciTeX Template Research - Makefile                 #"
	@echo "############################################################"
	@echo ""
	@echo "Setup & Installation:"
	@echo "  make install                       # Install Python dependencies"
	@echo "  make install-dev                   # Install dev dependencies (testing, linting)"
	@echo "  make setup                         # Complete setup (install + verify)"
	@echo "  make setup-writer                  # Clone writer template project (example_paper)"
	@echo ""
	@echo "Running Scripts:"
	@echo "  make run-mnist                     # Run complete MNIST pipeline"
	@echo "  make run-mnist-download            # Download MNIST data"
	@echo "  make run-mnist-plot-digits         # Plot MNIST digits"
	@echo "  make run-mnist-plot-umap           # Create UMAP visualization"
	@echo "  make run-mnist-clf-svm             # Train SVM classifier"
	@echo "  make run-mnist-conf-mat            # Plot confusion matrix"
	@echo ""
	@echo "Cleaning:"
	@echo "  make clean                         # Clean script outputs"
	@echo "  make clean-mnist                   # Clean MNIST outputs only"
	@echo "  make clean-outputs                 # Clean all *_out directories"
	@echo "  make clean-data                    # Clean generated data files"
	@echo "  make clean-logs                    # Clean log files"
	@echo "  make clean-writer                  # Remove writer projects (use with caution!)"
	@echo "  make clean-all                     # Clean everything (outputs + data + cache)"
	@echo "  make clean-python                  # Clean Python cache files"
	@echo ""
	@echo "Code Quality:"
	@echo "  make format                        # Format all code (Python + Shell)"
	@echo "  make format-python                 # Format Python with ruff"
	@echo "  make format-shell                  # Format shell with shfmt + shellcheck"
	@echo "  make lint                          # Lint code with ruff"
	@echo "  make check                         # Run format + lint + test"
	@echo ""
	@echo "Testing:"
	@echo "  make test                          # Run all tests"
	@echo "  make test-verbose                  # Run tests with verbose output"
	@echo "  make test-sync                     # Sync test structure with scripts"
	@echo ""
	@echo "Information:"
	@echo "  make info                          # Show project information"
	@echo "  make tree                          # Show project structure"
	@echo "  make verify                        # Verify installation and config"
	@echo "  make show-config                   # Display configuration files (requires yq)"
	@echo ""

# ============================================
# Installation & Setup
# ============================================
install:
	@echo "Installing Python dependencies..."
	@if [ -f requirements.txt ]; then \
		$(PIP) install -r requirements.txt; \
		echo "Dependencies installed"; \
	else \
		echo "requirements.txt not found"; \
		exit 1; \
	fi

install-dev:
	@echo "Installing development dependencies..."
	@$(PIP) install pytest pytest-cov ruff black isort mypy
	@echo "Development dependencies installed"

setup: install
	@echo "Setting up project..."
	@mkdir -p $(DATA_DIR)
	@mkdir -p $(DATA_DIR)/mnist/figures
	@mkdir -p $(DATA_DIR)/mnist/models
	@mkdir -p $(DATA_DIR)/mnist/raw
	@echo "Project setup complete"
	@$(MAKE) verify
	@echo ""
	@echo "To create a writer project, run:"
	@echo "  make setup-writer"
	@echo "  or manually: scitex writer clone $(WRITER_DIR)/your_paper_name"
	@echo ""

setup-writer:
	@$(MGMT_SCRIPTS)/setup-writer.sh

verify:
	@$(MGMT_SCRIPTS)/verify.sh

# ============================================
# Running MNIST Scripts
# ============================================
run-mnist:
	@$(MGMT_SCRIPTS)/run-mnist.sh all

run-mnist-download:
	@$(MGMT_SCRIPTS)/run-mnist.sh download

run-mnist-plot-digits:
	@$(MGMT_SCRIPTS)/run-mnist.sh digits

run-mnist-plot-umap:
	@$(MGMT_SCRIPTS)/run-mnist.sh umap

run-mnist-clf-svm:
	@$(MGMT_SCRIPTS)/run-mnist.sh svm

run-mnist-conf-mat:
	@$(MGMT_SCRIPTS)/run-mnist.sh confmat

# ============================================
# Cleaning
# ============================================
clean:
	@$(MGMT_SCRIPTS)/clean.sh

clean-mnist:
	@$(MGMT_SCRIPTS)/clean.sh mnist

clean-outputs:
	@$(MGMT_SCRIPTS)/clean.sh outputs

clean-data:
	@$(MGMT_SCRIPTS)/clean.sh data

clean-logs:
	@$(MGMT_SCRIPTS)/clean.sh logs

clean-all:
	@$(MGMT_SCRIPTS)/clean.sh all

clean-python:
	@$(MGMT_SCRIPTS)/clean.sh python

clean-writer:
	@$(MGMT_SCRIPTS)/clean.sh writer

# ============================================
# Testing
# ============================================
test:
	@echo "Running tests..."
	@if command -v pytest >/dev/null 2>&1; then \
		pytest $(TESTS_DIR) -q; \
	else \
		echo "pytest not installed. Run: make install-dev"; \
		exit 1; \
	fi

test-verbose:
	@echo "Running tests (verbose)..."
	@if command -v pytest >/dev/null 2>&1; then \
		pytest $(TESTS_DIR) -v; \
	else \
		echo "pytest not installed. Run: make install-dev"; \
		exit 1; \
	fi

test-sync:
	@echo "Synchronizing test structure with scripts..."
	@$(TESTS_DIR)/sync_tests_with_scripts.sh
	@echo "Test synchronization complete"

# ============================================
# Code Quality
# ============================================
format: format-python format-shell
	@echo ""
	@echo "All formatting and linting complete!"

format-python:
	@echo "Formatting Python code with ruff..."
	@if command -v ruff >/dev/null 2>&1; then \
		ruff format $(SCRIPTS_DIR) $(TESTS_DIR) --quiet || echo "Ruff formatting completed with warnings"; \
		echo "Python formatting complete"; \
	else \
		echo "Ruff not found. Install with: pip install ruff"; \
		exit 1; \
	fi

format-shell:
	@echo "Formatting and linting shell scripts..."
	@if command -v shfmt >/dev/null 2>&1; then \
		find $(SCRIPTS_DIR) $(MGMT_SCRIPTS) -name "*.sh" \
			! -path "*/node_modules/*" \
			! -path "*/.venv/*" \
			-exec shfmt -w -i 4 -bn -ci -sr {} + \
			2>&1 || echo "shfmt formatting completed with warnings"; \
		echo "Shell formatting complete!"; \
	else \
		echo "shfmt not found. Install with: go install mvdan.cc/sh/v3/cmd/shfmt@latest"; \
		echo "Skipping shell formatting..."; \
	fi
	@if command -v shellcheck >/dev/null 2>&1; then \
		find $(SCRIPTS_DIR) $(MGMT_SCRIPTS) -name "*.sh" \
			! -path "*/node_modules/*" \
			! -path "*/.venv/*" \
			-exec shellcheck --severity=error {} + \
			2>&1 || echo "ShellCheck found errors"; \
		echo "Shell linting complete!"; \
	else \
		echo "shellcheck not found. Install with: sudo apt-get install shellcheck"; \
		echo "Skipping shell linting..."; \
	fi

lint: lint-python

lint-python:
	@echo "Linting Python code with ruff..."
	@if command -v ruff >/dev/null 2>&1; then \
		ruff check $(SCRIPTS_DIR) $(TESTS_DIR) --quiet || echo "Ruff found issues"; \
		echo "Linting complete"; \
	else \
		echo "Ruff not found. Install with: pip install ruff"; \
		exit 1; \
	fi

check: format lint test
	@echo ""
	@echo "All checks passed!"

# ============================================
# Information & Diagnostics
# ============================================
info:
	@echo "Project Information:"
	@echo ""
	@echo "  Project: SciTeX Template Research"
	@echo "  Python: $$($(PYTHON) --version 2>&1)"
	@echo "  Scripts: $$(find $(SCRIPTS_DIR) -name "*.py" | wc -l) Python files"
	@echo "  Config: $$(ls -1 $(CONFIG_DIR)/*.yaml 2>/dev/null | wc -l) YAML files"
	@echo ""
	@echo "  MNIST Scripts:"
	@echo "    - $$(ls -1 $(MNIST_DIR)/*.py 2>/dev/null | wc -l) scripts"
	@echo "    - $$(ls -1d $(MNIST_DIR)/*_out 2>/dev/null | wc -l) output directories"
	@echo ""
	@if [ -d $(DATA_DIR)/mnist/figures ]; then \
		echo "  Generated Figures: $$(ls -1 $(DATA_DIR)/mnist/figures/*.jpg 2>/dev/null | wc -l)"; \
	fi
	@if [ -d $(DATA_DIR)/mnist/models ]; then \
		echo "  Saved Models: $$(ls -1 $(DATA_DIR)/mnist/models/*.pkl 2>/dev/null | wc -l)"; \
	fi

tree:
	@echo "Project Structure:"
	@if command -v tree >/dev/null 2>&1; then \
		tree -L 3 -I '__pycache__|*.pyc|.git|.venv|*.egg-info|.pytest_cache|.ruff_cache|.mypy_cache' -C; \
	else \
		echo "tree command not found. Install with: sudo apt-get install tree"; \
		ls -R; \
	fi

show-config:
	@echo "Configuration Files:"
	@echo ""
	@if command -v yq >/dev/null 2>&1; then \
		for cfg in $(CONFIG_DIR)/*.yaml; do \
			if [ -f "$$cfg" ]; then \
				echo "$$cfg:"; \
				yq -C '.' "$$cfg" 2>/dev/null || cat "$$cfg"; \
				echo ""; \
			fi; \
		done; \
	else \
		echo "yq not installed. Showing raw YAML files:"; \
		echo "(Install yq for colored output: sudo apt-get install yq or brew install yq)"; \
		echo ""; \
		for cfg in $(CONFIG_DIR)/*.yaml; do \
			if [ -f "$$cfg" ]; then \
				echo "$$cfg:"; \
				cat "$$cfg"; \
				echo ""; \
			fi; \
		done; \
	fi

# ============================================
# Utility Targets
# ============================================
.SILENT: help

# EOF
