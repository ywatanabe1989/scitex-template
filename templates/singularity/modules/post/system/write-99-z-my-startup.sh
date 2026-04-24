#!/usr/bin/env bash
# Script created on: 2024-06-23 14:37:13
# Script path: /home/ywatanabe/proj/singularity_template/modules/post/system/startup.sh

TARGET_PATH="${SINGULARITY_ROOTFS}/.singularity.d/env/99-z-my-startup.sh"

# touch "$TARGET_PATH"

cat << 'EOH' > "$TARGET_PATH"
#!/usr/bin/env bash
# Script created on: 2024-06-23 14:37:13
# Script path: /home/ywatanabe/proj/singularity_template/modules/post/system/99-z-my-startup.sh -> $TARGET_PATH

# This script functions similarly to .bashrc

# for f in "$SINGULARITYENV_MYHOME"/.bash.d/all/*.sh "$SINGULARITYENV_MYHOME"/.bash.d/secrets/*.sh; do
#     . $f
# done


# /home/ywatanabe/.bash.d/all/000-if.sh: line 14: `if-host': not a valid identifier
# for f in /home/ywatanabe/.bash.d/all/*.sh /home/ywatanabe/.bash.d/secrets/*.sh; do
#     . $f
# done

# clear

if ! [[ "$PWD" ]]; then
    cd $PWD
fi

# if [ -f env/bin/activate ]; then
#     source env/bin/activate
# fi

clear
echo You are running in $SINGULARITY_CONTAINER

# alias ipy="ipython"
# alias lt='ls -ltrhF'
# EOF
EOH


chmod 755 "$TARGET_PATH"

# EOF
