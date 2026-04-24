#!/usr/bin/env bash
# Script created on: 2024-06-23 14:37:13
# Script path: /home/ywatanabe/proj/singularity_template/modules/post/system/startup.sh

for f in "$MYHOME"/.bash.d/all/*.sh "$MYHOME"/.bash.d/secrets/*.sh; do
    . $f
done

clear

if ! [[ "$PWD" ]]; then
    cd $PWD
fi

# if [ -f env/bin/activate ]; then
#     source env/bin/activate
# fi

echo $SINGULARITY_CONTAINER

# EOF
