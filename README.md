# Dotfiles

Kali-style shell configs with a customizable emoji prompt for bash and zsh.

Example twoline prompt:

```text
┌──(you😈hostname)-[~/projects]
└─$
```

## Installation

```bash
cd ~
git clone https://github.com/Narehood/dotfiles.git
cd dotfiles
./install.sh
```

Optionally switch your login shell to zsh:

```bash
chsh -s /bin/zsh
```

## Prompt settings

Appearance is controlled by:

`~/.config/dotfiles/prompt.conf`

Install copies the defaults there on first run and **never overwrites** an existing file. Repo defaults live in [`config/prompt.conf`](config/prompt.conf).

After editing the config, open a new shell (or `source ~/.zshrc` / `source ~/.bashrc`).

### Available options

| Setting | Values | Default | Description |
| --- | --- | --- | --- |
| `PROMPT_ALTERNATIVE` | `twoline`, `oneline`, `backtrack` | `twoline` | Prompt layout (see below) |
| `NEWLINE_BEFORE_PROMPT` | `yes`, `no` | `yes` | Blank line before each prompt (after the first) |
| `PROMPT_EMOJI` | any emoji or text | `😈` | Symbol between user and host (normal user) |
| `PROMPT_EMOJI_ROOT` | any emoji or text | `💀` | Symbol between user and host (root) |
| `PROMPT_COLOR_USER` | color name | `green` | Frame / path accent color (normal user) |
| `INFO_COLOR_USER` | color name | `boldblue` | User and host color (normal user) |
| `PROMPT_COLOR_ROOT` | color name | `brightblue` | Frame / path accent color (root) |
| `INFO_COLOR_ROOT` | color name | `boldred` | User and host color (root) |
| `SHOW_RPROMPT` | `yes`, `no` | `no` | Zsh only: right prompt with exit status and background jobs |

### Layout options (`PROMPT_ALTERNATIVE`)

| Value | What you get |
| --- | --- |
| `twoline` | Kali-style two-line prompt with emoji between user and host |
| `oneline` | Single-line `user@host:path$` using your configured colors |
| `backtrack` | Classic BackTrack-style red `user@host` / blue path prompt |

### Color names

Use any of these for the `*_COLOR_*` settings:

| Group | Names |
| --- | --- |
| Basic | `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white` |
| Bright | `brightblack`, `brightred`, `brightgreen`, `brightyellow`, `brightblue`, `brightmagenta`, `brightcyan`, `brightwhite` |
| Bold | `boldred`, `boldgreen`, `boldblue` |

Underscored bright names also work (for example `bright_blue`).

### Example config

```bash
# ~/.config/dotfiles/prompt.conf

PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes

PROMPT_EMOJI=😈
PROMPT_EMOJI_ROOT=💀

PROMPT_COLOR_USER=green
INFO_COLOR_USER=boldblue
PROMPT_COLOR_ROOT=brightblue
INFO_COLOR_ROOT=boldred

SHOW_RPROMPT=no
```

### Zsh tip

Press **Ctrl-P** to toggle between `twoline` and `oneline` without editing the config.

### Reset to defaults

```bash
rm ~/.config/dotfiles/prompt.conf
cd ~/dotfiles && ./install.sh
```

## Uninstallation

```bash
cd ~/dotfiles
./uninstall.sh
```

This restores previous dotfile backups (`.dtbak`) and leaves `~/.config/dotfiles/prompt.conf` alone so your settings survive a reinstall.
