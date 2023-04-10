# General
# Dont require typing cd
setopt auto_cd
# Enable command autocorrection
setopt correct

# History of visited directories
# Extend dir stack size
DIRSTACKSIZE=10
# Make cd automatically push to stack
setopt autopushd 
# Swap minus and plus  
setopt pushdminus
# Push silently
setopt pushdsilent
# Push without arguments pushes current dir instead of swapping order
setopt pushdtohome
# Follow XDG directories layout (this is repeated to prevent overwrites)
export HISTFILE="$XDG_STATE_HOME/zsh/history"

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
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

# Setup pyenv
eval "$(pyenv init -)"
eval "$(pyenv init - virtualenv)"

# Reconcile homebrew and pyenv
alias brew="env PATH=${PATH//$(pyenv root)\/shims:/} brew"

# Plugins
fpath+="$XDG_CONFIG_HOME/zsh/pure"
autoload -U promptinit; promptinit
prompt pure
case $OSTYPE in
darwin*)
	source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source /opt/homebrew/opt/fzf/shell/completion.zsh
	source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
	;;
linux-gnu)
	# Debian-based
	if [ -f /etc/lsb-release ]; then
		zsh_syntax_highlighting="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
		zsh_autosuggestions="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
		zsh_fzf_completion="/usr/share/doc/fzf/examples/completion.zsh"
		zsh_fzf_bindings="/usr/share/doc/fzf/examples/key-bindings.zsh"
	# Arch
	elif [ -f /etc/arch-release ]; then
		zsh_syntax_highlighting="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
		zsh_autosuggestions="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
		zsh_fzf_completion="/usr/share/fzf/completion.zsh"
	    zsh_fzf_bindings="/usr/share/fzf/key-bindings.zsh"
	fi

	source "$zsh_syntax_highlighting"
	source "$zsh_fzf_completion"
	source "$zsh_fzf_bindings"
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
