.PHONY: help \
	install \
	test-changed \
	test-full \
	test-watch \
	test-watch-changed \
	ci-container \
	ci-act \
	ci-local \
	lint \
	clean \
	build \
	upload-pypi-test \
	upload-pypi \
	release

# Configuration
PACKAGE_NAME := semantic_search_engine
TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

# Directories
SRC_DIR := src/$(PACKAGE_NAME)
TESTS_DIR := tests
REPORTS_DIR := tests/reports

# Pytest
TEST_FULL_DIR := $(REPORTS_DIR)/full
TEST_CHANGED_DIR := $(REPORTS_DIR)/changed
TEST_WATCH_FULL_DIR := $(REPORTS_DIR)/watch-full
TEST_WATCH_CHANGED_DIR := $(REPORTS_DIR)/watch-changed

# Source-Test agreement
AGREEMENT_DIR := $(REPORTS_DIR)/agreement
AGREEMENT_SCRIPT := tests/custom/test_src_test_agreement.py

# CI
CI_SCRIPTS_DIR := tests/github_actions
CI_CONTAINER_SCRIPT := $(CI_SCRIPTS_DIR)/run_ci_container.sh
CI_ACT_SCRIPT := $(CI_SCRIPTS_DIR)/run_ci_act_and_container.sh
CI_LOCAL_SCRIPT := $(CI_SCRIPTS_DIR)/run_ci_local.sh

# User restriction function
define check-user-access
	@if [ -n "$$CLAUDE_ID" ]; then \
		echo "Error: This command is not allowed for automated agents."; \
		exit 1; \
	fi
endef

# Test variation factory function
define run-test-variation
	@echo "Running $(1) tests..."
	@mkdir -p $(2)/$(TIMESTAMP)
	@COVERAGE_FILE=$(2)/$(TIMESTAMP)/.coverage pytest $(3) $(TESTS_DIR)/ -v \
		--cov=$(SRC_DIR) \
		--cov-report=html:$(2)/$(TIMESTAMP)/htmlcov \
		--cov-report=json:$(2)/$(TIMESTAMP)/coverage.json \
		--cov-report=term-missing | tee $(2)/$(TIMESTAMP)/output.txt
	@ln -sf $(TIMESTAMP) $(2)/latest
	@echo "$(1) report saved to $(2)/$(TIMESTAMP)/"
	@echo "Coverage in JSON saved to: $(2)/$(TIMESTAMP)/coverage.json"
	@echo "Coverage in HTML saved to: $(2)/$(TIMESTAMP)/htmlcov/index.html"
	@echo "Runtime log saved to: $(2)/$(TIMESTAMP)/output.txt"
	@echo "Latest symlink updated: $(2)/latest -> $(2)/$(TIMESTAMP)"
endef



define run-watch-variation
	@echo "Running $(1) tests in watch mode..."
	@mkdir -p $(2)/$(TIMESTAMP)
	pytest-watch --runner "COVERAGE_FILE=$(2)/$(TIMESTAMP)/.coverage pytest $(3) $(TESTS_DIR)/ -v \
		--cov=$(SRC_DIR) \
		--cov-report=html:$(2)/$(TIMESTAMP)/htmlcov \
		--cov-report=json:$(2)/$(TIMESTAMP)/coverage.json \
		--cov-report=term-missing"
	@ln -sf $(TIMESTAMP) $(2)/latest
	@echo "$(1) report saved to $(2)/$(TIMESTAMP)/"
	@echo "Coverage in JSON saved to: $(2)/$(TIMESTAMP)/coverage.json"
	@echo "Coverage in HTML saved to: $(2)/$(TIMESTAMP)/htmlcov/index.html"
	@echo "Latest symlink updated: $(2)/latest -> $(2)/$(TIMESTAMP)"
endef


help:
	@echo "Available commands:"
	@echo "  install        Install project dependencies"
	@echo ""
	@echo "  agreement      Test src-test one-on-one agreements → $(AGREEMENT_DIR)/latest/"
	@echo "  agreement-coverage → $(AGREEMENT_DIR)/latest/"
	@echo ""
	@echo "  test-full      Run full tests with coverage → $(TEST_FULL_DIR)/latest/"
	@echo "  test-changed   Run tests affected by code changes → $(TEST_CHANGED_DIR)/latest/"
	@echo ""
	@echo "  test-watch     Run full tests in watch mode → $(TEST_WATCH_FULL_DIR)/latest/"
	@echo "  test-watch-changed Run changed tests in watch mode → $(TEST_WATCH_CHANGED_DIR)/latest/"
	@echo ""
	@echo "  ci-container   Run CI with containers (Apptainer → Docker fallback)"
	@echo "  ci-act         Run GitHub Actions locally with Act and Apptainer"
	@echo "  ci-local       Run local CI emulator (Python-based)"
	@echo ""
	@echo "  lint           Run linting and formatting"
	@echo "  clean          Remove cache files"
	@echo ""
	@echo "  build          Build package for distribution → build/, dist/"
	@echo "  upload-pypi-test Upload to Test PyPI"
	@echo "  upload-pypi    Upload to PyPI"
	@echo "  release        Clean, build, and upload to PyPI"

install:
	pip install -e ".[dev]"
	pre-commit install

agreement:
	@mkdir -p $(AGREEMENT_DIR)/$(TIMESTAMP)
	@python $(AGREEMENT_SCRIPT) > $(AGREEMENT_DIR)/$(TIMESTAMP)/report.txt
	@ln -sf $(TIMESTAMP) $(AGREEMENT_DIR)/latest
	@echo "Agreement report saved to $(AGREEMENT_DIR)/$(TIMESTAMP)/"
	@echo "Latest symlink updated: $(AGREEMENT_DIR)/latest"
	@cat $(AGREEMENT_DIR)/latest/report.txt

agreement-coverage:
	@mkdir -p $(AGREEMENT_DIR)/$(TIMESTAMP)
	@result=$$(python $(AGREEMENT_SCRIPT) --format summary --package-only); \
	data=$$(echo "$$result" | grep "Package tests with sources" | cut -d: -f2 | tr -d ' '); \
	echo "$$result" > $(AGREEMENT_DIR)/$(TIMESTAMP)/coverage.txt; \
	echo "$$data" > $(AGREEMENT_DIR)/$(TIMESTAMP)/coverage_summary.txt; \
	ln -sf $(TIMESTAMP) $(AGREEMENT_DIR)/latest; \
	echo "Coverage: $$data"

test-full:
	$(call run-test-variation,full,$(TEST_FULL_DIR),)

test-changed:
	$(call run-test-variation,changed,$(TEST_CHANGED_DIR),--testmon)

test-watch:
	$(call run-watch-variation,full,$(TEST_WATCH_FULL_DIR),)

test-watch-changed:
	$(call run-watch-variation,changed,$(TEST_WATCH_CHANGED_DIR),--testmon)

ci-container:
	$(call check-user-access)
	@echo "🏗️ Running CI on HPC with containers (direct)..."
	./$(CI_CONTAINER_SCRIPT)

ci-act:
	$(call check-user-access)
	@echo "⚡ Running GitHub Actions locally with Singularity..."
	./$(CI_ACT_SCRIPT)

ci-local:
	$(call check-user-access)
	@echo "🚀 Running local CI emulator (Python-based)..."
	./$(CI_LOCAL_SCRIPT)

lint:
	@echo "Running linting and formatting..."
	ruff check src/ $(TESTS_DIR)/
	ruff format src/ $(TESTS_DIR)/

clean:
	$(call check-user-access)
	@echo "Cleaning cache files..."
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	rm -rf .mypy_cache .pytest_cache $(REPORTS_DIR)/coverage.json tests/github/local_ci_report.json build/ dist/ *.egg-info/ 2>/dev/null || true
	chmod -R +w .ruff_cache 2>/dev/null || true
	rm -rf .ruff_cache 2>/dev/null || true

build:
	$(call check-user-access)
	@echo "Building package..."
	python -m build

upload-pypi-test:
	$(call check-user-access)
	@echo "Uploading to Test PyPI..."
	python -m twine upload --repository testpypi dist/*

upload-pypi:
	$(call check-user-access)
	@echo "Uploading to PyPI..."
	python -m twine upload dist/*

release: build upload-pypi clean
	$(call check-user-access)
	@echo "Package released to PyPI!"
