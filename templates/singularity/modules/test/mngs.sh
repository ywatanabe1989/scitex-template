#!/bin/bash
# Script created on: 2024-06-15 20:13:08
# Script path: /home/ywatanabe/proj/singularity_template/modules/test/mngs.sh

# Argument Parser
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) # Display help
            echo "Usage: $0 [-h|--help] [-a|--argument ARGUMENT]"
            exit 0
            ;;
        -a|--argument) # Example argument
            ARGUMENT="$2"
            shift
            ;;
        *) # Unknown option
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Parameters
LOG_PATH="$0".log

# Functions
main() {
    # Opening
    echo -e "$0 starts."

    # Main
    python --version
    python -c "import mngs; from pprint import pprint; print(mngs.__version__); pprint(mngs.res.get_specs())"

    # Closing
    echo -e "$0 ends"
}

touch $LOG_PATH
main | tee $LOG_PATH
echo -e "
Logged to: $LOG_PATH"

# EOF
