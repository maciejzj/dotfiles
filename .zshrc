# General
# Dont require typing cd
setopt auto_cd
# Enable command autocorrection
setopt correct

# History of visited directoties
# Extend dir stack size
DIRSTACKSIZE=8
# Make cd automatically push to stack
setopt autopushd 
# Swap minus and plus  
setopt pushdminus
# Push silently
setopt pushdsilent
# Push without arguments pushes current dir instead of swapping order
setopt pushdtohome

# Make ctrl+u work like in other shells (delete from cursor to beginning
# of the line, instead of deleting the whole line)
bindkey \^U backward-kill-line
# Make ctrl+x ctrl+e work like in other shells (edit current command in editor)
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Autocompletion
# This is normally lazy loaded on completion, but here we load it early to able
# to bind shift-tab keymap
zmodload zsh/complist
# Enable colors in zsh completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# Enable menu box in zsh completion
zstyle ':completion:*' menu yes select
# Bind shift-tab to previous completion item
bindkey -M menuselect '^[[Z' reverse-menu-complete
# Enable completion
autoload -Uz compinit
compinit

# Enable pyenv
eval "$(pyenv init -)"
eval "$(pyenv init - virtualenv)"
# Reconcile homebrew and pyenv
alias brew="env PATH=${PATH//$(pyenv root)\/shims:/} brew"

# Plugins
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure
case $OSTYPE in
darwin*)
	source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source /opt/homebrew/opt/fzf/shell/completion.zsh
	;;
linux-gnu)
	# Debian-based
	if [ -f /etc/lsb-release ]; then
		zsh_syntax_highlighting="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
		zsh_completion="/usr/share/doc/fzf/examples/completion.zsh"
		zsh_autosuggestions="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
	# Arch
	elif [ -f /etc/arch-release ]; then
		zsh_syntax_highlighting="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
		zsh_completion="/usr/share/fzf/completion.zsh"
		zsh_autosuggestions="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
	fi

	source "$zsh_syntax_highlighting"
	source "$zsh_completion"
	if [ $TERM = linux ]; then
		# Enabled only in bare tty
		PURE_PROMPT_SYMBOL=">"
	else
		# Enabled only in terminal emulators
		source "$zsh_autosuggestions"
	fi
	;;
esac
# Disable underline in syntax highlighting
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
