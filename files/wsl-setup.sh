#!/bin/sh
export DEBIAN_FRONTEND=noninteractive > /dev/null

echo 'Updating packages information...'
sudo apt-get update > /dev/null

echo 'Upgrading packages...'
sudo apt-get dist-upgrade -yqq > /dev/null

echo 'Configuring systemd...'
cd ~
wget -O ~/wsl.tar.gz https://github.com/diddledan/ubuntu-wsl2-systemd-script/archive/master.tar.gz > /dev/null
tar xzvf ~/wsl.tar.gz > /dev/null
cd ~/ubuntu-wsl2-systemd-script-master
bash ubuntu-wsl2-systemd-script.sh
rm -rf ~/wsl.tar.gz ~/ubuntu-wsl2-systemd-script-master

echo 'Configuring display...'
cat <<- "EOF" | tee -a ~/.bashrc > /dev/null
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
export DISPLAY=$(cat /etc/resolv.conf | grep -Po "(?<=nameserver\s)([\d.]+)"):0
export LIBGL_ALWAYS_INDIRECT=1
export PULSE_SERVER=tcp:$(cat /etc/resolv.conf | grep -Po "(?<=nameserver\s)([\d.]+)")
EOF
