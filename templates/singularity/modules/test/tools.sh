#!/bin/bash
# Script created on: 2024-06-15 20:13:08
# Script path: /home/ywatanabe/proj/singularity_template/modules/test/tools.sh

commands=(autossh htop git emacs openssh wget gcc make ffmpeg git-crypt htop pigz python rg sshpass tree)

for command in "${commands[@]}"; do
    which $command
done

# EOF
