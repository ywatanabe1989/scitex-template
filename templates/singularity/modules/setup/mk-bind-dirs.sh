#!/bin/bash
# Script created on: 2024-06-17 17:10:20
# Script path: /home/ywatanabe/proj/singularity_template/modules/setup/setup.sh

# Make $SINGULARITY_BIND directories
# Example: echo $SINGULARITY_BIND # /work,/storage,/local,/home
for dir in $(echo $SINGULARITY_BIND | tr ',' ' '); do
    mkdir -p "${SINGULARITY_ROOTFS}${dir}"
done

# EOF
