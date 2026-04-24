#!/usr/bin/env bash
# Script created on: 2024-06-23 14:37:13
# Script path: /home/ywatanabe/proj/singularity_template/modules/post/system/startup.sh

alias lt='ls -ltrhF'
alias ipy='ipython'

# if [ -n "$SINGULARITYENV_MYHOME" ]; then
#     for f in "$SINGULARITYENV_MYHOME"/.bash.d/all/*.sh "$SINGULARITYENV_MYHOME"/.bash.d/secrets/*.sh; do
#         if [ -f "$f" ]; then
#             source "$f"
#             # # Use a subshell to prevent errors from stopping the entire script
#             # (set +e; source "$f") 2>/dev/null
#         fi
#     done
# fi

# if [ -n "$MYHOME" ]; then
#     for f in "$MYHOME"/.bash.d/all/*.sh "$MYHOME"/.bash.d/secrets/*.sh; do
#         if [ -f "$f" ]; then
#             source "$f"
#             # # Use a subshell to prevent errors from stopping the entire script
#             # (set +e; source "$f") 2>/dev/null
#         fi
#     done
# fi

# if [ -n "$PWD" ]; then
#     cd "$PWD"
# fi



################################################################################
# for f in "$MYHOME"/.bash.d/all/*.sh "$MYHOME"/.bash.d/secrets/*.sh; do
#     . $f
# done

# clear

# if ! [[ "$PWD" ]]; then
#     cd $PWD
# fi

# # if [ -f env/bin/activate ]; then
# #     source env/bin/activate
# # fi

# echo $SINGULARITY_CONTAINER

# # EOF
