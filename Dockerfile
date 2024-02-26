FROM archlinux:base-devel

RUN <<EOF
set -eux -o pipefail

# Install some minimal packages to bootstrap the system
pacman -Sy --noconfirm sudo
# Enable users in the wheel group to sudo without needing to enter their password
sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
# Create a "human" user in the wheel group
useradd --groups wheel --create-home --shell /usr/sbin/zsh human
EOF


# The rest of the setup can be done as a non-root user
# though this user has sudo-powers!
USER human
WORKDIR /home/human
RUN <<EOF
set -eux -o pipefail
TMP=`mktemp -d`
cd $TMP

curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
tar -xvf yay.tar.gz && cd yay/

makepkg --syncdeps --noconfirm
sudo pacman -U --noconfirm yay-*.pkg.tar.zst

yay -Syu --noconfirm fzf git go inetutils neovim helm htop jq kubectl python ripgrep tmux wget which xdg-user-dirs zip zsh-syntax-highlighting

cd ~
rm -rf $TMP

xdg-user-dirs-update
mkdir -p ~/git/gitlab/njdart && cd ~/git/gitlab/njdart && git clone https://gitlab.com/njdart/dot-files && cd ~/git/gitlab/njdart/dot-files && ./setup.py
cd ~
git config --global core.excludesfile ~/.config/gitignore_global

sudo pacman -Sc --noconfirm

EOF


CMD ["/usr/sbin/zsh"]
