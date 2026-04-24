#!/bin/bash
# -*- coding: utf-8 -*-
# Timestamp: "2025-12-09 05:00:01 (ywatanabe)"
# File: ./management/scripts/setup-writer.sh

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

SCITEX_DIR="${GIT_ROOT}/scitex"
WRITER_DIR="${SCITEX_DIR}/writer"  # clones directly here: ./scitex/writer/01_manuscript/...
GIT_STRATEGY="${GIT_STRATEGY:-parent}"

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Clone writer template into scitex/writer/.

Options:
    -g, --git-strategy STRATEGY    Git strategy: child|parent|origin|none (default: ${GIT_STRATEGY})
    -h, --help                     Show this help message

Git Strategies:
    child   - Create isolated git in project directory
    parent  - Use parent git repository (default)
    origin  - Preserve template's original git history
    none    - Disable git initialization

Examples:
    $(basename "$0")                           # Clone with parent strategy
    $(basename "$0") -g child                  # Clone with independent git
EOF
}

main() {
    local git_strategy="${GIT_STRATEGY}"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -g|--git-strategy)
                git_strategy="$2"
                shift 2
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
                shift
                ;;
        esac
    done

    # Check if writer is already initialized (look for 01_manuscript)
    if [[ -d "${WRITER_DIR}/01_manuscript" ]]; then
        echo_warning "Writer already exists at ${WRITER_DIR}"
        echo_info "Contents:"
        ls -1 "${WRITER_DIR}" | head -10 | tee -a "$LOG_PATH"
        exit 0
    fi

    echo_header "Cloning writer template"
    echo_info "Destination: ${WRITER_DIR}"
    echo_info "Git strategy: ${git_strategy}"

    if ! command -v scitex &>/dev/null; then
        echo_error "scitex command not found"
        echo_warning "Install with: pip install scitex"
        exit 1
    fi

    scitex writer clone "${WRITER_DIR}" --git-strategy "${git_strategy}" 2>&1 | tee -a "$LOG_PATH"

    echo_success "Writer project created successfully!"
    echo ""
    echo_info "To compile the manuscript:"
    echo "  cd ${WRITER_DIR}" | tee -a "$LOG_PATH"
    echo "  scitex writer compile manuscript" | tee -a "$LOG_PATH"
}

main "$@"

# EOF