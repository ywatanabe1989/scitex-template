#!/usr/bin/env bash
# Script created on: 2024-06-23 15:19:48
# Script path: /home/ywatanabe/proj/singularity_template/modules/post/system/HOSTNAME.sh

export HOSTNAME="$HOSTNAME"-singularity > $SINGULARITY_ENVIRONMENT
hostnamectl set-hostname $HOSTNAME

# EOF
