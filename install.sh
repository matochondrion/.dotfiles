# install nix
curl -L https://nixos.org/nix/install | sh

# source nix
. ~/.nix-profile/etc/profile.d/nix.sh

# install packages
nix-env -iA nixpkgs.zsh
nix-env -iA nixpkgs.antibody
nix-env -iA nixpkgs.git
nix-env -iA nixpkgs.neovim
nix-env -iA nixpkgs.tmux
nix-env -iA nixpkgs.stow
nix-env -iA nixpkgs.yarn
nix-env -iA nixpkgs.fzf
nix-env -iA nixpkgs.ripgrep
nix-env -iA nixpkgs.bat
nix-env -iA nixpkgs.gnumake
nix-env -iA nixpkgs.gcc
nix-env -iA nixpkgs.direnv

# stow dotfiles
stow git
stow nvim
stow tmux
stow zsh

# add zsh as a login shell
command -v zsh | sudo tee -a /etc/shells

# use zsh as default shell
sudo chsh -s $(which zsh) $USER

# bundle zsh plugins 
antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh

# install neovim plugins
nvim --headless +PlugInstall +qall

# Use kitty terminal on MacOS
[ `uname -s` = 'Darwin' ] && stow kitty
