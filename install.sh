#!/bin/bash
set -euo pipefail

# Find all dot files then if the original file exists, create a backup
# Once backed up to {file}.dtbak symlink the new dotfile in place
# Use absolute path to prevent path traversal vulnerabilities
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    if [ -e "$HOME/$filename" ]; then
        # Skip if already the correct symlink
        if [ -L "$HOME/$filename" ] && [ "$(readlink -f "$HOME/$filename")" = "$(readlink -f "$file")" ]; then
            continue
        fi
        mv -f "$HOME/$filename" "$HOME/${filename}.dtbak"
    fi
    ln -s "$SCRIPT_DIR/$filename" "$HOME/$filename"
done < <(find "$SCRIPT_DIR" -maxdepth 1 -name ".*" -type f -print0)

# First-run prompt settings (never overwrite an existing user config)
USER_PROMPT_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/prompt.conf"
mkdir -p "$(dirname "$USER_PROMPT_CONF")"
if [ ! -e "$USER_PROMPT_CONF" ]; then
    cp "$SCRIPT_DIR/config/prompt.conf" "$USER_PROMPT_CONF"
    echo "Created prompt settings at $USER_PROMPT_CONF"
else
    echo "Keeping existing prompt settings at $USER_PROMPT_CONF"
fi

# Install vim-addons ZSH and ZSH extras when apt is available
echo "installing extras"

if command -v apt >/dev/null 2>&1; then
    if ! sudo apt update; then
        echo "Warning: Failed to update package lists. Continuing without packages." >&2
    elif ! sudo apt -y install vim-scripts zsh zsh-syntax-highlighting zsh-autosuggestions; then
        echo "Warning: Failed to install packages. Dotfiles are linked; install zsh plugins manually if needed." >&2
    fi
else
    echo "Warning: apt not found; skipped package install (zsh, syntax-highlighting, autosuggestions)." >&2
fi

echo "Installed"
echo "Prompt settings: $USER_PROMPT_CONF"
echo "Edit that file to change emoji, colors, and layout, then open a new shell."
echo "use chsh -s /bin/zsh to switch to ZSH shell"
