#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-12-09 05:00:00 (ywatanabe)"
# File: ./management/scripts/clean.sh

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

SCRIPTS_DIR="${GIT_ROOT}/scripts"
DATA_DIR="${GIT_ROOT}/data"
SCITEX_DIR="${GIT_ROOT}/scitex"
WRITER_DIR="${SCITEX_DIR}/writer"  # ./scitex/writer/01_manuscript/...
SKIP_CONFIRM="${SKIP_CONFIRM:-false}"

usage() {
    cat << EOF
Usage: $(basename "$0") [TARGET]

Clean project outputs and caches.

Targets:
    outputs     Clean all *_out directories in scripts/
    mnist       Clean MNIST outputs only
    logs        Clean log files
    python      Clean Python cache files (__pycache__, .pyc, etc.)
    data        Clean generated data files (requires confirmation)
    writer      Remove writer projects (requires confirmation)
    all         Clean everything (requires confirmation)
    (default)   Same as: outputs logs python

Options:
    -y, --yes   Skip confirmation prompts
    -h, --help  Show this help message

Examples:
    $(basename "$0")              # Clean outputs, logs, python cache
    $(basename "$0") mnist        # Clean MNIST outputs only
    $(basename "$0") all -y       # Clean everything without confirmation
EOF
}

confirm() {
    local message="$1"
    local confirm_text="${2:-yes}"

    if [[ "$SKIP_CONFIRM" == "true" ]]; then
        return 0
    fi

    echo_warning "$message"
    printf "Type '%s' to confirm: " "$confirm_text"
    read -r response
    [[ "$response" == "$confirm_text" ]]
}

clean_outputs() {
    echo_header "Cleaning script outputs"
    find "$SCRIPTS_DIR" -type d -name "*_out" -exec rm -rf {} + 2>&1 | tee -a "$LOG_PATH" || true
    echo_success "All outputs cleaned"
}

clean_mnist() {
    echo_header "Cleaning MNIST outputs"
    rm -rf "${SCRIPTS_DIR}/mnist"/*_out/ 2>&1 | tee -a "$LOG_PATH" || true
    echo_success "MNIST outputs cleaned"
}

clean_logs() {
    echo_header "Cleaning log files"
    find "$SCRIPTS_DIR" -type f -name "*.log" -delete 2>&1 | tee -a "$LOG_PATH" || true
    find "$SCRIPTS_DIR" -type d -name "RUNNING" -exec rm -rf {}/logs \; 2>&1 | tee -a "$LOG_PATH" || true
    find "$SCRIPTS_DIR" -type d -name "FINISHED_SUCCESS" -exec rm -rf {}/*/logs \; 2>&1 | tee -a "$LOG_PATH" || true
    find "$SCRIPTS_DIR" -type d -name "FINISHED_FAILED" -exec rm -rf {}/*/logs \; 2>&1 | tee -a "$LOG_PATH" || true
    echo_success "Logs cleaned"
}

clean_python() {
    echo_header "Cleaning Python cache"
    find "$GIT_ROOT" -type d -name "__pycache__" -exec rm -rf {} + 2>&1 | tee -a "$LOG_PATH" || true
    find "$GIT_ROOT" -type f -name "*.pyc" -delete 2>&1 | tee -a "$LOG_PATH" || true
    find "$GIT_ROOT" -type f -name "*.pyo" -delete 2>&1 | tee -a "$LOG_PATH" || true
    find "$GIT_ROOT" -type d -name "*.egg-info" -exec rm -rf {} + 2>&1 | tee -a "$LOG_PATH" || true
    find "$GIT_ROOT" -type d -name ".pytest_cache" -exec rm -rf {} + 2>&1 | tee -a "$LOG_PATH" || true
    find "$GIT_ROOT" -type d -name ".ruff_cache" -exec rm -rf {} + 2>&1 | tee -a "$LOG_PATH" || true
    find "$GIT_ROOT" -type d -name ".mypy_cache" -exec rm -rf {} + 2>&1 | tee -a "$LOG_PATH" || true
    echo_success "Python cache cleaned"
}

clean_data() {
    if ! confirm "This will delete all generated data files!" "yes"; then
        echo_warning "Cancelled"
        return 0
    fi

    echo_header "Cleaning data directory"
    rm -rf "${DATA_DIR}/mnist"/*.npy 2>&1 | tee -a "$LOG_PATH" || true
    rm -rf "${DATA_DIR}/mnist"/*.pkl 2>&1 | tee -a "$LOG_PATH" || true
    rm -rf "${DATA_DIR}/mnist/figures"/*.jpg 2>&1 | tee -a "$LOG_PATH" || true
    rm -rf "${DATA_DIR}/mnist/figures"/*.csv 2>&1 | tee -a "$LOG_PATH" || true
    rm -rf "${DATA_DIR}/mnist/models"/*.pkl 2>&1 | tee -a "$LOG_PATH" || true
    echo_success "Data cleaned"
}

clean_writer() {
    echo_error "This will DELETE all writer projects!"
    echo_error "Each writer project is an independent git repository."
    echo_error "Make sure you have pushed any uncommitted changes!"

    if ! confirm "" "DELETE WRITER PROJECTS"; then
        echo_warning "Cancelled"
        return 0
    fi

    echo_header "Removing writer projects"
    if [[ -d "$WRITER_DIR" ]]; then
        rm -rf "${WRITER_DIR}"/*/ 2>&1 | tee -a "$LOG_PATH"
        echo_success "Writer projects removed"
    else
        echo_warning "No writer directory found"
    fi
}

clean_all() {
    if ! confirm "This will delete ALL generated files!" "DELETE ALL"; then
        echo_warning "Cancelled"
        return 0
    fi

    clean_outputs
    clean_logs
    clean_python
    SKIP_CONFIRM=true clean_data
    rm -rf "${DATA_DIR}/mnist/raw"/* 2>&1 | tee -a "$LOG_PATH" || true
    echo_success "Complete cleanup done"
}

main() {
    local target="default"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -y|--yes)
                SKIP_CONFIRM=true
                shift
                ;;
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
                target="$1"
                shift
                ;;
        esac
    done

    case "$target" in
        outputs)  clean_outputs ;;
        mnist)    clean_mnist ;;
        logs)     clean_logs ;;
        python)   clean_python ;;
        data)     clean_data ;;
        writer)   clean_writer ;;
        all)      clean_all ;;
        default)
            clean_outputs
            clean_logs
            clean_python
            echo_success "Cleaned outputs, logs, and python cache"
            ;;
        *)
            echo_error "Unknown target: $target"
            usage
            exit 1
            ;;
    esac
}

main "$@"

# EOF
