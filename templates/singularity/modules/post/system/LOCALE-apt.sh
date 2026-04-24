#!/usr/bin/env bash
# Script created on: 2024-06-23 20:12:17
# Script path: /home/ywatanabe/proj/singularity_template/modules/post/system/LOCALE-apt.sh

export LC_ALL=en_US.UTF-8
echo export LC_ALL=$LC_ALL >> $SINGULARITY_ENVIRONMENT
export LANG=en_US.UTF-8
echo export LANG=$LANG >> $SINGULARITY_ENVIRONMENT

apt update
apt install -y coreutils grep sed
apt install -y locales

# Generate the en_US.UTF-8 locale
locale-gen en_US.UTF-8

# Set the locale
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo "export LC_ALL=en_US.UTF-8" >> /etc/profile.d/locale.sh
echo "export LANG=en_US.UTF-8" >> /etc/profile.d/locale.sh

# EOF
