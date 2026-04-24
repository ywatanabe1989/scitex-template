export LC_ALL=en_US.UTF-8
echo export LC_ALL=$LC_ALL >> $SINGULARITY_ENVIRONMENT
export LANG=en_US.UTF-8
echo export LANG=$LANG >> $SINGULARITY_ENVIRONMENT

dnf install -y coreutils grep sed
dnf install -y glibc-langpack-en
echo "export LC_ALL=en_US.UTF-8" >> /etc/profile.d/locale.sh
echo "export LANG=en_US.UTF-8" >> /etc/profile.d/locale.sh
