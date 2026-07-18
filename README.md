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

| Setting | Values | Default | Description |
| --- | --- | --- | --- |
| `PROMPT_ALTERNATIVE` | `twoline`, `oneline`, `backtrack` | `twoline` | Prompt layout |
| `NEWLINE_BEFORE_PROMPT` | `yes`, `no` | `yes` | Blank line before each prompt |
| `PROMPT_EMOJI` | any emoji/text | `😈` | Symbol between user and host |
| `PROMPT_EMOJI_ROOT` | any emoji/text | `💀` | Symbol when running as root |
| `PROMPT_COLOR_USER` | color name | `green` | Frame color (normal user) |
| `INFO_COLOR_USER` | color name | `boldblue` | User/host color (normal user) |
| `PROMPT_COLOR_ROOT` | color name | `brightblue` | Frame color (root) |
| `INFO_COLOR_ROOT` | color name | `boldred` | User/host color (root) |
| `SHOW_RPROMPT` | `yes`, `no` | `no` | Zsh right prompt (exit status / jobs) |

Color names: `green`, `blue`, `red`, `yellow`, `cyan`, `magenta`, `white`, `brightblue`, `boldblue`, `boldred`, and similar.

After editing the config, open a new shell (or `source ~/.zshrc` / `source ~/.bashrc`).

### Zsh tip

Press **Ctrl-P** to toggle between twoline and oneline without editing the config.

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
