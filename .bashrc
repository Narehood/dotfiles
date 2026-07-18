# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Treat unset variables as an error when substituting
set -u

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Resolve this rc to the dotfiles repo (follows symlink), then load prompt settings
if [ -z "${DOTFILES_DIR:-}" ]; then
    _dotfiles_rc="${BASH_SOURCE[0]}"
    if command -v readlink >/dev/null 2>&1; then
        _dotfiles_rc="$(readlink -f "$_dotfiles_rc" 2>/dev/null || readlink "$_dotfiles_rc" 2>/dev/null || echo "$_dotfiles_rc")"
    fi
    DOTFILES_DIR="$(cd "$(dirname "$_dotfiles_rc")" && pwd)"
    unset _dotfiles_rc
fi
if [ -f "$DOTFILES_DIR/lib/prompt-config.sh" ]; then
    # shellcheck disable=SC1091
    . "$DOTFILES_DIR/lib/prompt-config.sh"
fi

configure_bash_prompt() {
    local prompt_color info_color prompt_symbol reset_color bold_path
    reset_color='\[\033[0m\]'
    bold_path='\[\033[0;1m\]'

    if [ "${EUID:-$(id -u)}" -eq 0 ]; then
        prompt_color="$(prompt_bash_color "$PROMPT_COLOR_ROOT")"
        info_color="$(prompt_bash_color "$INFO_COLOR_ROOT")"
        prompt_symbol="$PROMPT_EMOJI_ROOT"
    else
        prompt_color="$(prompt_bash_color "$PROMPT_COLOR_USER")"
        info_color="$(prompt_bash_color "$INFO_COLOR_USER")"
        prompt_symbol="$PROMPT_EMOJI"
    fi

    case "$PROMPT_ALTERNATIVE" in
        oneline)
            PS1="${debian_chroot:+($debian_chroot)}${info_color}\u@\h${reset_color}:${prompt_color}\w${reset_color}\$ "
            ;;
        backtrack)
            PS1="${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
            ;;
        *)
            # twoline (default) — Kali-style frame with emoji
            PS1="${prompt_color}┌──${debian_chroot:+($debian_chroot)──}(${info_color}\u${prompt_symbol}\h${prompt_color})-[${bold_path}\w${prompt_color}]"$'\n'"${prompt_color}└─${info_color}\$${reset_color} "
            ;;
    esac
}

if [ "$color_prompt" = yes ]; then
    configure_bash_prompt
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Optional blank line before each prompt (matches zsh NEWLINE_BEFORE_PROMPT)
if [ "${NEWLINE_BEFORE_PROMPT:-}" = yes ]; then
    _dotfiles_newline_prompt() {
        if [ -z "${_NEW_LINE_BEFORE_PROMPT:-}" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            printf '\n'
        fi
    }
    if [[ "${PROMPT_COMMAND:-}" != *_dotfiles_newline_prompt* ]]; then
        if [ -n "${PROMPT_COMMAND:-}" ]; then
            PROMPT_COMMAND="_dotfiles_newline_prompt;${PROMPT_COMMAND}"
        else
            PROMPT_COMMAND="_dotfiles_newline_prompt"
        fi
    fi
fi

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    # shellcheck disable=SC1090
    . ~/.bash_aliases
fi

if [ -f ~/.bash_exports ]; then
    # shellcheck disable=SC1090
    . ~/.bash_exports
fi

if [ -f ~/.bash_wrappers ]; then
    # shellcheck disable=SC1090
    . ~/.bash_wrappers
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
