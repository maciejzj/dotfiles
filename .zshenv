# General

# Language
export LANG=en_US.UTF-8

# Text editor
export EDITOR=nvim
# Disable vi mode in shell
bindkey -e

# Set history length
HISTFILE=~/.zhistory
HISTSIZE=SAVEHIST=100000
setopt sharehistory
setopt extendedhistory
setopt histignorespace

# Enable colors for man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
# Make fzf follow 16 ANSI terminal colors
export FZF_DEFAULT_OPTS='--color=16'
# Make bat follow 16 ANSI terminal colors
export BAT_THEME='ansi'

# Disable less history
export LESSHISTFILE=/dev/null
# Exclude underscore commands from correction suggestions
CORRECT_IGNORE="[_|.]*"

# Aliases

# Aliases are here and not in the .zshrc, because only .zshenv
# is sourced by the shell invoked through vim's '!' external command.

# Prompt for confirmation when overwriting files
alias cp='cp -i'
alias mv='mv -i'
# Enable colors for grep
alias grep='grep --color=auto'
# Pygmentize coloring
alias pyg='pygmentize -f terminal'
# Dir history alias
alias dh='dirs -v'
# Make sure python is python3
alias python='python3'
alias pip='pip3'
# Use nvim
alias vim='nvim'
alias vimdiff='nvim -d'
alias view='nvim -R'

case ${OSTYPE} in
darwin*)
	# Add user local binaries to PATH
	export PATH="${PATH}:${HOME}/.local/bin"
	# Disable MacOS shell state restoration which is annoying with tmux
	export SHELL_SESSIONS_DISABLE=1

	# Aliases for ls
	alias l='ls -h'
	alias la='ls -ah'
	alias ll='ls -hl'
	alias lla='ls -ahl'
	# Colors for BSD programs
	export CLICOLOR=1
	;;
linux-gnu)
	# Add user's Python modules to PATH
	export PATH="$PATH:/home/$USER/.local/bin"
	# Add pyenv to PATH
	export PATH="$PATH:/home/$USER/.pyenv/bin"

	# Aliases for ls
	alias ls='ls --color=auto'
	alias l='ls -h --color=auto'
	alias la='ls -ah --color=auto'
	alias ll='ls -hl --color=auto'
	alias lla='ls -ahl --color=auto'

	# Commands for xorg programms
	# Start mupdf in inverted colors mode
	mupdf="mupdf -I"
	;;
esac
