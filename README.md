# My dotfiles

My config with a simple installation script. Works on MacOS, Arch Linux, and
Debian based distros. Should be easily portable to all Linux distros (and maybe
BSDs).

![demo_screenshot](https://github.com/maciejzj/dotfiles/blob/master/screen.png?raw=true)

Focused around zsh, tmux and (neo)vim. Comes with features like zsh syntax
coloring, autosuggestion, neovim treesitter, built-in LSP support, treesitter,
telescope, nice tmux bindings, theming, fzf integration and much more. Crafted
to make terminal apps use 16 ANSI colors, so the theme stays consistent and is
easy to modify from one place. Includes some minimalist xorg programs and
config.

Neovim config is written in Lua.

# Installation

Run: `./install` to deploy the dotfiles.

> **NOTICE:** The installation script isn't updated on a regular basis, so use
> it with caution.

On Linux it is best to use the dotfiles with my 
[suckless builds](https://github.com/maciejzj/suckless-builds).

## Fine-tuning

Some config pieces may require minimal fixing, e.g. readjust some lines in
`config.tmux` to make it work with `xclip`.
