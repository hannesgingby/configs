#!/usr/bin/env bash
set -euo pipefail

CONFIGS="${DOTFILES:-$HOME/configs}"

echo "Setup..."

defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder 2>/dev/null || true

brew bundle --file="$CONFIGS/Brewfile"

SF_MONO_SRC="/System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts"
if ! ls ~/Library/Fonts/SFMono-* &>/dev/null; then
  cp "$SF_MONO_SRC"/SFMono-* ~/Library/Fonts/
fi

if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
fi

if ! command -v bun &>/dev/null; then
  curl -fsSL https://bun.sh/install | bash
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

git config --global user.name "Hannes Gingby"
git config --global user.email "hannes@gingby.se"
git config --global init.defaultBranch main
git config --global core.excludesfile "$HOME/.gitignore"
curl -fsSL https://raw.githubusercontent.com/github/gitignore/main/Global/macOS.gitignore \
  > "$HOME/.gitignore"

bash "$CONFIGS/symlink.sh" --mac

echo "Done"
