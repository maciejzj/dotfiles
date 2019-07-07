# General
# Language
export LANG=en_US.UTF-8
# Dont require typing cd
setopt auto_cd
# Enavle command autocorrection
ENABLE_CORRECTIO="true"

# History of visited directoties
# Extend dir stack size
DIRSTACKSIZE=8
# Make cd automatically push to stack
setopt autopushd 
# Swap minus and plus  
setopt pushdminus
# Push silently
setopt pushdsilent
# Push without argumetns pushes current dir instead of swapping order
setopt pushdtohome
# Dir hisotory alias
alias dh='dirs -v'

# Colors
# To generate colors see: https://geoff.greer.fm/lscolors/
# Colors for BSD programs
export LSCOLORS="exfxcxdxbxegedabagacad"
# Enable BSD colors
export CLICOLOR=1
# Colors for Linux programs
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
# Enable colors for grep
alias grep='grep --color=auto'
# Enable colors for man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Autocompletion
# Enble colors in zsh completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# Enable menu box in zsh completion
zstyle ':completion:*' menu yes select
# Enable completion
autoload -Uz compinit
compinit
# When completion is loading show dots
COMPLETION_WAITING_DOTS="true"

# Plugins
# Prompt theme Pure, installed from: https://github.com/sindresorhus/pure
autoload -U promptinit; promptinit
prompt pure
# Fish like autosuggestion plugin, installed from: https://github.com/zsh-users/zsh-autosuggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Fish like syntax coloring plugin, installed from: https://github.com/zsh-users/zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Disable underline in syntax highlighting
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Aliases
# Exa, installed with: brew install exa 
alias l='exa'
alias ll='exa --long --group --git'
alias lla='exa --long --group --git -a'
# Aliases for ls
alias ls='ls -h'
# Aliases for grep
alias grep='grep --color=auto'
# Aliases for cp and mv
# Prompt for confirmation when overwriting files
alias cp='cp -i'
alias mv='mv -i'
# Aliases for Bigger, installed from: https://github.com/MaciejZj/Bigger
alias sc='bigger.py c'
alias ss='bigger.py s'
alias sm='bigger.py m'
alias sb='bigger.py b'
# Alias for waking home pc
alias wmpc='wakeonlan -i 192.168.1.255 -p 1234 6C:62:6D:5A:40:2E'
# Alias for ctags generation
alias ctags="`brew --prefix`/bin/ctags"

