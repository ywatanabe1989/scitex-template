#!/bin/bash

install-gh() {
    curl -fsSL https://cli.github.com/packages/rpm/gh-cli.repo | tee /etc/yum.repos.d/github-cli.repo
    dnf -y install gh

    gh --version
}

install-basics() {
    dnf -y update

    dnf -y install setup
    dnf -y groupinstall "Development Tools"
    dnf -y install dnf-plugins-core
    dnf -y install epel-release
    dnf config-manager --set-enabled powertools
    dnf config-manager --add https://negativo17.org/repos/epel-multimedia.repo

    dnf -y upgrade
}

install-dnf-packages () {
    dnf update

    dnf -y install libffi
    dnf -y install libffi-devel
    dnf -y install mesa-libGL
    dnf -y install mesa-libGL-devel
    dnf -y install glibc
    dnf -y install glibc-devel
    dnf -y install htop && htop --version
    dnf -y install ffmpeg
    dnf -y install ffmpeg-devel
    dnf -y install ripgrep && rg --version
    dnf -y install portaudio
    dnf -y install portaudio-devel
    dnf -y install git && git --version
    dnf -y install emacs && emacs --version
    dnf -y install openssl
    dnf -y install openssl-devel
    dnf -y install wget && wget --version
    dnf -y install gcc && gcc --version
    dnf -y install make && make --version
    dnf -y install sshpass
    dnf -y install langpacks-en glibc-all-langpacks
    dnf -y install which
    dnf -y install clear

    dnf -y upgrade
}

install-tree () {
    wget https://gitlab.com/OldManProgrammer/unix-tree/-/archive/2.1.1/unix-tree-2.1.1.tar.bz2
    tar -xjvf unix-tree-2.1.1.tar.bz2
    cd unix-tree-2.1.1
    make -j32
    make -j32 install PREFIX=/usr/local
    cd ..
    rm -rf unix-tree*

    tree --version
}

install-autossh() {
    dnf install
    wget http://www.harding.motd.ca/autossh/autossh-1.4e.tgz
    tar -xf autossh-1.4e.tgz
    cd autossh-1.4e
    ./configure
    make -j32
    make -j32 install PREFIX=/usr/local
    cd ..
    rm autossh* -rf

    authossh --version
}

install-git-crypt () {
    git clone https://github.com/AGWA/git-crypt.git
    cd git-crypt
    make -j 32
    make install -j 32 PREFIX=/usr/local

    git-crypt --version
}

main () {
    install-basics
    install-dnf-packages
    # After the basic installations are completed.
    install-tree
    install-autossh
    install-git-crypt
    install-gh
}

main

# EOF
