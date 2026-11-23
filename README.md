# dotfiles

Personal macOS dotfiles, originally forked from
[holman/dotfiles](https://github.com/holman/dotfiles). **This repo is public**:
nothing secret or employer-internal goes in here.

## new machine

```sh
git clone https://github.com/bolek/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap   # asks work/personal + git identity, symlinks *.symlink into ~
bin/dot            # homebrew, Brewfiles, every topic's install.sh, macOS defaults
```

Then, by hand: sign in to 1Password, import the GPG key (and set `signingkey`
in `~/.gitconfig.local`), `gh auth login`, `claude` and `codex` logins.

## layout

Topic folders. In each:

- `*.zsh` is loaded into every shell. `path.zsh` loads first, `completion.zsh` loads last.
- `*.symlink` is linked into `$HOME` as `~/.<name>` by `script/bootstrap`.
- `install.sh` is run by `script/install` (and so by `dot`).

`bin/` is on `$PATH`; `functions/` is autoloaded.

## work vs personal

`script/bootstrap` writes `DOTFILES_PROFILE=work|personal` to `~/.localrc`.

| What | Where |
| --- | --- |
| Shared on every machine | topic folders, `Brewfile` |
| Only on the active profile | `profiles/<profile>/`: `Brewfile`, `*.zsh`, `install.sh`, `claude/settings.json` |
| Machine-local or secret | `~/.localrc`, `~/.gitconfig.local` (identity and signing key) |
| Private but versioned | `~/.dotfiles-private/` (separate private repo): its `*.zsh` are loaded and `claude/settings.json` is layered in |

## AI tools

- `claude/install.sh` installs Claude desktop and Claude Code (native installer).
  It builds `~/.claude/settings.json` by layering repo defaults, then profile,
  then private, then existing settings. Settings you already have win.
- `openai/install.sh` installs ChatGPT desktop and the Codex CLI, and seeds
  `~/.codex/config.toml`.
