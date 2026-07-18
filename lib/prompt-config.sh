# Shared prompt settings loader for bash and zsh.
# Expects DOTFILES_DIR to point at the repository root.

# Resolve DOTFILES_DIR if the caller did not set it
if [ -z "${DOTFILES_DIR:-}" ]; then
    _prompt_cfg_src=""
    if [ -n "${ZSH_VERSION:-}" ]; then
        # Keep ${(%):-%x} quoted so Bash does not parse it when sourcing
        eval '_prompt_cfg_src="${(%):-%x}"'
    elif [ -n "${BASH_SOURCE[0]:-}" ]; then
        _prompt_cfg_src="${BASH_SOURCE[0]}"
    fi
    if [ -n "$_prompt_cfg_src" ]; then
        if command -v readlink >/dev/null 2>&1; then
            _prompt_cfg_src="$(readlink -f "$_prompt_cfg_src" 2>/dev/null || readlink "$_prompt_cfg_src" 2>/dev/null || echo "$_prompt_cfg_src")"
        fi
        DOTFILES_DIR="$(cd "$(dirname "$_prompt_cfg_src")/.." && pwd)"
    fi
    unset _prompt_cfg_src
fi

# Defaults from the repo, then optional user override
if [ -n "${DOTFILES_DIR:-}" ] && [ -f "$DOTFILES_DIR/config/prompt.conf" ]; then
    # shellcheck disable=SC1091
    . "$DOTFILES_DIR/config/prompt.conf"
fi

if [ -f "${HOME}/.config/dotfiles/prompt.conf" ]; then
    # shellcheck disable=SC1091
    . "${HOME}/.config/dotfiles/prompt.conf"
fi

# Safe fallbacks if anything is still unset
: "${PROMPT_ALTERNATIVE:=twoline}"
: "${NEWLINE_BEFORE_PROMPT:=yes}"
: "${PROMPT_EMOJI:=😈}"
: "${PROMPT_EMOJI_ROOT:=💀}"
: "${PROMPT_COLOR_USER:=green}"
: "${INFO_COLOR_USER:=boldblue}"
: "${PROMPT_COLOR_ROOT:=brightblue}"
: "${INFO_COLOR_ROOT:=boldred}"
: "${SHOW_RPROMPT:=no}"

# Map a named color to a bash PS1 ANSI escape (with \[ \] wrapping).
# Usage: prompt_bash_color green  -> \[\033[0;32m\]
prompt_bash_color() {
    case "$1" in
        black)      printf '%s' '\[\033[0;30m\]' ;;
        red)        printf '%s' '\[\033[0;31m\]' ;;
        green)      printf '%s' '\[\033[0;32m\]' ;;
        yellow)     printf '%s' '\[\033[0;33m\]' ;;
        blue)       printf '%s' '\[\033[0;34m\]' ;;
        magenta)    printf '%s' '\[\033[0;35m\]' ;;
        cyan)       printf '%s' '\[\033[0;36m\]' ;;
        white)      printf '%s' '\[\033[0;37m\]' ;;
        brightblack|bright_black)   printf '%s' '\[\033[0;90m\]' ;;
        brightred|bright_red)       printf '%s' '\[\033[0;91m\]' ;;
        brightgreen|bright_green)   printf '%s' '\[\033[0;92m\]' ;;
        brightyellow|bright_yellow) printf '%s' '\[\033[0;93m\]' ;;
        brightblue|bright_blue)     printf '%s' '\[\033[0;94m\]' ;;
        brightmagenta|bright_magenta) printf '%s' '\[\033[0;95m\]' ;;
        brightcyan|bright_cyan)     printf '%s' '\[\033[0;96m\]' ;;
        brightwhite|bright_white)   printf '%s' '\[\033[0;97m\]' ;;
        boldred)    printf '%s' '\[\033[1;31m\]' ;;
        boldgreen)  printf '%s' '\[\033[1;32m\]' ;;
        boldblue)   printf '%s' '\[\033[1;34m\]' ;;
        *)          printf '%s' '\[\033[0;32m\]' ;;
    esac
}

# Map a named color to a zsh %F{...} color token (name only).
# bright* maps to the numeric bright codes zsh understands.
prompt_zsh_color() {
    case "$1" in
        brightblack|bright_black)   printf '%s' '90' ;;
        brightred|bright_red)       printf '%s' '91' ;;
        brightgreen|bright_green)   printf '%s' '92' ;;
        brightyellow|bright_yellow) printf '%s' '93' ;;
        brightblue|bright_blue)     printf '%s' '94' ;;
        brightmagenta|bright_magenta) printf '%s' '95' ;;
        brightcyan|bright_cyan)     printf '%s' '96' ;;
        brightwhite|bright_white)   printf '%s' '97' ;;
        boldred)    printf '%s' 'red' ;;
        boldgreen)  printf '%s' 'green' ;;
        boldblue)   printf '%s' 'blue' ;;
        *)          printf '%s' "$1" ;;
    esac
}

# Active emoji for the current user (root vs normal)
prompt_active_emoji() {
    if [ "${EUID:-$(id -u)}" -eq 0 ]; then
        printf '%s' "$PROMPT_EMOJI_ROOT"
    else
        printf '%s' "$PROMPT_EMOJI"
    fi
}
