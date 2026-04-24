#!/bin/bash

################################################################################
## Installation
##
## 1. Place this file in $HOME as ~/singularity-aliases.sh
## 2. Add the line ". $HOME/singularity-aliases.sh" to automatically load this file
## 3. Store your sif file or sandbox directory under SG_HOME_DIR or SG_WORK_DIR as follows:
##
## .project_A/.singularity
## ├── project_A.sif # project_A.sif
## ├── project_A # project_A
## ├── image.sif (symlink -> project_A.sif)
## └── image (symlink -> project_A)
################################################################################

################################################################################
# Fixed environmental variables
################################################################################
# PATH
export SINGULARITYENV_PATH=$PATH
export SINGULARITYENV_PYTHONPATH=$PATHONPATH
export SINGULARITYENV_PYTHONSTARTUP=$PYTHONSTARTUP
export SINGULARITYENV_CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES

# Base
export SINGULARITYENV_USER=$USER
export SINGULARITYENV_DISPLAY=$DISPLAY
export SINGULARITYENV_OUTDATED_IGNORE=$OUTDATED_IGNORE
export SG_HOME_DIR="$HOME/.singularity/"
export SG_CD_DIR="./.singularity/"
export SG_STATIC_SIF="image.sif"
export SG_SAND_SIF="sandbox"

# Fixme: Should they be exported?
export SG_STATIC_SIF_HOME_PATH=${SG_HOME_DIR}${SG_STATIC_SIF}
export SG_STATIC_SIF_CD_PATH=${SG_CD_DIR}${SG_STATIC_SIF}
export SG_SAND_SIF_HOME_PATH=${SG_HOME_DIR}${SG_SAND_SIF}
export SG_SAND_SIF_CD_PATH=${SG_CD_DIR}${SG_SAND_SIF}


################################################################################
# Adjustabale environmental variables
################################################################################

# ## Helper functions
# echo_eval () {
#     command=$1
#     echo "$command"
#     echo
#     eval "$command"
# }
# alias ee='echo_eval'

## Working with .sif files (-> ./.singularity/image.sif)
# Current directory
sshell() { ee "singularity shell $SG_BASE_OPTIONS $SG_STATIC_SIF_CD_PATH"; }
spy () {
    IMAGE_PATH=${SG_CD_DIR}${SG_STATIC_SIF}
    ee "singularity exec -f -c --nv $SG_STATIC_SIF_CD_PATH python3 $@"
}
sipy () {
    IMAGE_PATH=${SG_CD_DIR}${SG_STATIC_SIF}
    ee "singularity exec -f -c --nv $SG_STATIC_SIF_CD_PATH ipython $@"
}
sjpy () {
    IMAGE_PATH=${SG_CD_DIR}${SG_STATIC_SIF}
    ee "singularity exec -f -c --nv $SG_STATIC_SIF_CD_PATH jupyter-notebook $@"
}
# Home
sshell-home() { ee "singularity shell $SG_BASE_OPTIONS $SG_STATIC_SIF_HOME_PATH"; }
spy-home() {
    IMAGE_PATH=${SG_HOME_DIR}${SG_STATIC_SIF}
    ee "singularity exec -f -c --nv $SG_STATIC_SIF_HOME_PATH python3 $@"
}
sipy-home() {
    IMAGE_PATH=${SG_HOME_DIR}${SG_STATIC_SIF}
    ee "singularity exec -f -c --nv $SG_STATIC_SIF_HOME_PATH ipython $@"
}
sjpy-home() {
    IMAGE_PATH=${SG_HOME_DIR}${SG_STATIC_SIF}
    ee "singularity exec -f -c --nv $SG_STATIC_SIF_HOME_PATH jupyter-notebook $@"
}

## Working with Sandbox (-> ./.singularity/image)
sshells() { ee "singularity shell -f -c --nv $SG_SAND_SIF_CD_PATH"; }

sshellsw() {
    ee "unset SINGULARITY_BIND; singularity shell -f -c --writable $SG_SAND_SIF_CD_PATH"
}

_spy () {
    BIN=$1
    shift
    ee "singularity exec $SG_BASE_OPTIONS $SG_SAND_SIF_CD_PATH $BIN $@"
}

spyw () { _spy python; }
sipyw () { _spy ipython; }
sjpyw () { _spy jupyter-notebook; }




################################################################################
## Build commands
################################################################################
_organize_sandbox() {
    DEFINITION_FILE=$1
    SANDBOX_FILE=$2
    LOG_FILE=$3

    # Extract the base name without extension
    BASE_DIR="${DEFINITION_FILE%.*}"/
    DEF_DIR="${BASE_DIR%}"../definitions_files/

    # Create directories if they don't exist
    mkdir -p "$BASE_DIR" "$DEF_DIR"

    cp -v $DEFINITION_FILE $DEF_DIR
    mv -v $DEFINITION_FILE $SANDBOX_FILE $LOG_FILE $BASE_DIR
    }

# sif
_sbuild () {
    DEFINITION_FILE=$1
    IMAGE_PATH=$2
    LOG_PATH=$3
    shift 3
    OPTIONS="$@"

    # Calculation
    BASE_NAME="${DEFINITION_FILE%.*}"
    ORIG_DIR=`pwd`

    if [[ ! -f "$DEFINITION_FILE" ]]; then
        echo "Error: Definition file does not exist."
        return 1
    fi

    # Main
    ORIG_SINGULARITY_BIND=$SINGULARITY_BIND
    unset SINGULARITY_BIND
    ee "singularity build $OPTIONS $IMAGE_PATH $DEFINITION_FILE 2>&1 | tee ${LOG_PATH}"
    export SINGULARITY_BIND=$ORIG_SINGULARITY_BIND
}

sbuild () {
    # Example:
    # $ sbuild <YOUR_AWESOME_RECIPE>.def --fakeroot --remote # -> <YOUR_AWESOME_RECIPE>.sif

    DEFINITION_FILE=$1
    shift
    OPTIONS="$@"

    # Main
    BASE_NAME="${DEFINITION_FILE%.*}"
    STATIC_IMAGE_PATH=${BASE_NAME}.sif
    LOG_PATH=${BASE_NAME}.log

    echo $DEFINITION_FILE
    echo $STATIC_IMAGE_PATH
    echo $BASE_NAME
    echo $OPTIONS

    _sbuild "$DEFINITION_FILE" "$STATIC_IMAGE_PATH" "$LOG_PATH" "$OPTIONS"

}

sbuilds() {
    # Example:
    # $ sbuilds <YOUR_AWESOME_RECIPE>.def --fakeroot --remote # -> <YOUR_AWESOME_RECIPE>

    DEFINITION_FILE=$1
    shift
    OPTIONS="$@"

    # Main
    BASE_NAME="${DEFINITION_FILE%.*}"
    SAND_IMAGE_PATH=${BASE_NAME}-sandbox
    LOG_PATH=${BASE_NAME}-sandbox.log

    _sbuild "$DEFINITION_FILE" "$SAND_IMAGE_PATH" "$LOG_PATH" --fix-perms --sandbox "$OPTIONS"
    if [ -d "$SAND_IMAGE_PATH" ]; then
        _organize_sandbox "$DEFINITION_FILE" "$SAND_IMAGE_PATH" "$LOG_PATH"
    fi
}

## Bind directories
do-if-host "g01" export SINGULARITY_BIND="/work,/storage,/home"
do-if-host "g03" export SINGULARITY_BIND="/work,/storage,/home"
do-if-host "g02" export SINGULARITY_BIND="/work,/storage,/home"
do-if-host "g04" export SINGULARITY_BIND="/work,/storage,/home"
do-if-host "g05" export SINGULARITY_BIND="/work,/storage,/local,/home"
do-if-host "g06" export SINGULARITY_BIND="/work,/storage,/local,/home"
do-if-host "g06" alias singularity="singularity3.8.1"
do-if-host "g07" export SINGULARITY_BIND="/work,/storage,/local,/home"
do-if-host "g08" export SINGULARITY_BIND="/work,/storage,/home"

## Tools
do-if-host "nsurg" export SG_TOOLS_SIF=$HOME/proj/singularity_template/.singularity/tools-sandbox

alias autossh='singularity exec $SG_TOOLS_SIF autossh'
alias black='singularity exec $SG_TOOLS_SIF python -m black'
alias ffmpeg='singularity exec $SG_TOOLS_SIF ffmpeg'
alias flake8='singularity exec $SG_TOOLS_SIF python -m flake8'
alias git-crypt="singularity exec $SG_TOOLS_SIF git-crypt"
alias htop='singularity exec $SG_TOOLS_SIF htop'
alias pigz='singularity exec $SG_TOOLS_SIF pigz'
alias rg='singularity exec $SG_TOOLS_SIF rg'
alias sshpass='singularity exec $SG_TOOLS_SIF sshpass'
alias tree='singularity exec $SG_TOOLS_SIF tree'

# alias flake8='singularity exec $SG_TOOLS_SIF flake8'
# alias black="singularity exec $SG_TOOLS_SIF flake8"

# alias emacs='singularity exec $SG_TOOLS_SIF emacs-26.1'

# EOF
# open /: is a directory
# Config error: [Errno 30] Read-only file system: '/var/log/dnf.log': '/var/log/dnf.log'
# open /: is a directory
# open /.singularity.d/env/99-zz-02_custom_ps1.sh: read-only file system
# chmod: changing permissions of '/.singularity.d/env/99-zz-02_custom_ps1.sh': Read-only file system
# INFO:    Creating sandbox directory...
# INFO:    Build complete: .singularity/tools-2024-0615-sandbox
