#!/bin/bash
set -euo pipefail

# Remove symlinked dotfiles and restore .dtbak backups.
# Prompt settings at ~/.config/dotfiles/prompt.conf are left in place.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    if [ -L "$HOME/$filename" ]; then
        # Only remove if it points into this repo
        target="$(readlink -f "$HOME/$filename" 2>/dev/null || true)"
        if [ "$target" = "$SCRIPT_DIR/$filename" ] || [ "$(readlink "$HOME/$filename" 2>/dev/null || true)" = "$SCRIPT_DIR/$filename" ]; then
            rm -f "$HOME/$filename"
        fi
    fi
    # -e misses broken symlinks; -L includes them so stale .dtbak links are restored
    if [ -e "$HOME/${filename}.dtbak" ] || [ -L "$HOME/${filename}.dtbak" ]; then
        mv -f "$HOME/${filename}.dtbak" "$HOME/$filename"
    fi
done < <(find "$SCRIPT_DIR" -maxdepth 1 -name ".*" -type f -print0)

echo "Uninstalled"
echo "Prompt settings kept at ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/prompt.conf"
echo "(delete that file manually if you want to remove them too)"
