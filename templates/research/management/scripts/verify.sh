#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-12-09 05:00:00 (ywatanabe)"
# File: ./management/scripts/verify.sh

ORIG_DIR="$(pwd)"
THIS_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)"
LOG_PATH="$THIS_DIR/.$(basename $0).log"
echo > "$LOG_PATH"

GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"

GRAY='\033[0;90m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo_info() { echo -e "${GRAY}INFO: $1${NC}" | tee -a "$LOG_PATH"; }
echo_success() { echo -e "${GREEN}SUCC: $1${NC}" | tee -a "$LOG_PATH"; }
echo_warning() { echo -e "${YELLOW}WARN: $1${NC}" | tee -a "$LOG_PATH"; }
echo_error() { echo -e "${RED}ERRO: $1${NC}" | tee -a "$LOG_PATH"; }
echo_header() { echo_info "=== $1 ==="; }
# ---------------------------------------

PYTHON="${PYTHON:-python3}"
CONFIG_DIR="${GIT_ROOT}/config"

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Verify project installation and configuration.

Options:
    -h, --help  Show this help message

Checks:
    - Python version
    - Required Python packages
    - Configuration files
    - SciTeX installation
EOF
}

check_python() {
    echo_header "Python version"
    "$PYTHON" --version 2>&1 | tee -a "$LOG_PATH"
}

check_packages() {
    echo_header "Required packages"
    local packages=(scitex torch torchvision scikit-learn umap-learn seaborn numpy pandas matplotlib)

    for pkg in "${packages[@]}"; do
        if "$PYTHON" -c "import $pkg" 2>/dev/null; then
            echo -e "  ${GREEN}[OK]${NC} $pkg" | tee -a "$LOG_PATH"
        else
            echo -e "  ${RED}[MISSING]${NC} $pkg" | tee -a "$LOG_PATH"
        fi
    done
}

check_config() {
    echo_header "Configuration files"
    local configs=(PATH.yaml MNIST.yaml)

    for cfg in "${configs[@]}"; do
        if [[ -f "${CONFIG_DIR}/${cfg}" ]]; then
            echo -e "  ${GREEN}[OK]${NC} $cfg" | tee -a "$LOG_PATH"
        else
            echo -e "  ${YELLOW}[WARNING]${NC} $cfg (missing)" | tee -a "$LOG_PATH"
        fi
    done
}

check_scitex() {
    echo_header "SciTeX installation"
    if command -v scitex &>/dev/null; then
        echo -e "  ${GREEN}[OK]${NC} scitex command found" | tee -a "$LOG_PATH"
        scitex --version 2>&1 | tee -a "$LOG_PATH" || true
    else
        echo -e "  ${RED}[MISSING]${NC} scitex command not found" | tee -a "$LOG_PATH"
        echo_warning "Install with: pip install scitex"
    fi
}

check_directories() {
    echo_header "Directory structure"
    local dirs=(scripts config data tests scitex management)

    for dir in "${dirs[@]}"; do
        if [[ -d "${GIT_ROOT}/${dir}" ]]; then
            echo -e "  ${GREEN}[OK]${NC} $dir/" | tee -a "$LOG_PATH"
        else
            echo -e "  ${YELLOW}[WARNING]${NC} $dir/ (missing)" | tee -a "$LOG_PATH"
        fi
    done
}

main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                exit 0
                ;;
            -*)
                echo_error "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                shift
                ;;
        esac
    done

    echo_header "Verifying installation"
    echo "" | tee -a "$LOG_PATH"

    check_python
    echo "" | tee -a "$LOG_PATH"
    check_packages
    echo "" | tee -a "$LOG_PATH"
    check_config
    echo "" | tee -a "$LOG_PATH"
    check_scitex
    echo "" | tee -a "$LOG_PATH"
    check_directories
    echo "" | tee -a "$LOG_PATH"

    echo_success "Verification complete"
}

main "$@"

# EOF
