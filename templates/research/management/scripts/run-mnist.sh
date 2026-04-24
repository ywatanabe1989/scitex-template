#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-12-09 05:00:00 (ywatanabe)"
# File: ./management/scripts/run-mnist.sh

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
MNIST_DIR="${GIT_ROOT}/scripts/mnist"
DATA_DIR="${GIT_ROOT}/data"

usage() {
    cat << EOF
Usage: $(basename "$0") [STEP]

Run MNIST example pipeline.

Steps:
    all         Run complete pipeline (default)
    download    Download MNIST dataset (01_download.py)
    digits      Plot MNIST digits (02_plot_digits.py)
    umap        Create UMAP visualization (03_plot_umap_space.py)
    svm         Train SVM classifier (04_clf_svm.py)
    confmat     Plot confusion matrix (05_plot_conf_mat.py)

Options:
    -h, --help  Show this help message

Examples:
    $(basename "$0")              # Run complete pipeline
    $(basename "$0") download     # Download data only
    $(basename "$0") umap         # Run UMAP visualization only
EOF
}

run_step() {
    local step="$1"
    local script="$2"
    local description="$3"

    echo_header "$description"
    cd "$MNIST_DIR" && "$PYTHON" "$script" 2>&1 | tee -a "$LOG_PATH"
    echo_success "$step complete"
}

run_download() { run_step "Download" "01_download.py" "Downloading MNIST dataset"; }
run_digits()   { run_step "Digits" "02_plot_digits.py" "Plotting MNIST digits"; }
run_umap()     { run_step "UMAP" "03_plot_umap_space.py" "Creating UMAP visualization"; }
run_svm()      { run_step "SVM" "04_clf_svm.py" "Training SVM classifier"; }
run_confmat()  { run_step "ConfMat" "05_plot_conf_mat.py" "Plotting confusion matrix"; }

run_all() {
    run_download
    run_digits
    run_umap
    run_svm
    run_confmat

    echo "" | tee -a "$LOG_PATH"
    echo_success "MNIST pipeline complete!"
    echo "" | tee -a "$LOG_PATH"
    echo_info "Results available in:"
    echo "  - ${DATA_DIR}/mnist/figures/" | tee -a "$LOG_PATH"
    echo "  - ${MNIST_DIR}/*_out/" | tee -a "$LOG_PATH"
}

main() {
    local step="all"

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
                step="$1"
                shift
                ;;
        esac
    done

    if [[ ! -d "$MNIST_DIR" ]]; then
        echo_error "MNIST directory not found: ${MNIST_DIR}"
        exit 1
    fi

    case "$step" in
        all)      run_all ;;
        download) run_download ;;
        digits)   run_digits ;;
        umap)     run_umap ;;
        svm)      run_svm ;;
        confmat)  run_confmat ;;
        *)
            echo_error "Unknown step: $step"
            usage
            exit 1
            ;;
    esac
}

main "$@"

# EOF
