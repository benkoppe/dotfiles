fastfetch

if [ `tput colors` != "256" ]; then
	exec bash -l;
	return
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Check if a command exists
function can_haz() {
  which "$@" > /dev/null 2>&1
}

# XDG config home
export XDG_CONFIG_HOME="$HOME/.config"
# XDG cache home
export XDG_CACHE_HOME="$HOME/.cache"
# Base PATH
PATH="$PATH:/sbin:/usr/sbin:/bin:/usr/bin"

for path_candidate in /Applications/Xcode.app/Contents/Developer/usr/bin \
  /opt/homebrew/bin \
  /opt/homebrew/sbin \
  /opt/homebrew/ruby/bin \
  /home/linuxbrew/.linuxbrew/bin \
  /home/linuxbrew/.linuxbrew/sbin \
  /opt/local/bin \
  /opt/local/sbin \
  /usr/local/bin \
  /usr/local/sbin \
  /usr/local/go/bin \
  ~/bin \
  ~/.cabal/bin \
  ~/.cargo/bin \
  ~/.linuxbrew/bin \
  ~/.linuxbrew/sbin \
  ~/.rbenv/bin \
  ~/src/gocode/bin \
  ~/gocode \
  ~/.local/share/pnpm \
  ~/.local/bin
do
  if [[ -d "${path_candidate}" ]]; then
    path+=("${path_candidate}")
  fi
done
export PATH
# We will dedupe PATH at the end.

# Deal with brew if it's installed.
if can_haz brew; then
  BREW_PREFIX=$(brew --prefix)
  if [[ -d "${BREW_PREFIX}/bin" ]]; then
    export PATH="$PATH:${BREW_PREFIX}/bin"
  fi
  if [[ -d "${BREW_PREFIX}/sbin" ]]; then
    export PATH="$PATH:${BREW_PREFIX}/sbin"
  fi
fi

# Disable Oh-My_ZSH's internal updating
DISABLE_AUTO_UPDATE=true

export ZGENOM_DIR=~/.zgenom
export ZGENOM_SOURCE=$ZGENOM_DIR/zgenom.zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"

if [ ! -d "$ZGENOM_DIR" ]; then
	if nc -zw1 ifconfig.me 443; then
		git clone https://github.com/jandamm/zgenom.git "$ZGENOM_DIR"
	else
		echo "No internet connectivity. Cannot initialize zgenom"
		exit 1
	fi
fi

export ZSH_TAB_TITLE_DEFAULT_DIABLE_PREFIX=true
export ZSH_TAB_TITLE_ONLY_FOLDER=true
export ZSH_TAB_TITLE_CONCAT_FOLDER_PROCESS=true

# load compinit so autocompletion works well
autoload -Uz compinit && compinit -u -d $ZSH_CACHE/zcompdump


source $ZGENOM_SOURCE
if ! zgenom saved; then
	echo "Initializing zgenom"

	# Automatically run zgenom update and zgenom selfupdate every 7 days
	zgenom load unixorn/jpb.zshplugi

	# Ohmyzsh base library
	# zgenom ohmyzsh

	# Ohmyzsh plugins
	zgenom ohmyzsh plugins/git
	# Install ohmyzsh osx plugin if on macOS
	[[ $(uname -a | grep -ci Darwin) = 1 ]] && zgenom ohmyzsh plugins/macos
	(( $+commands[brew] )) && zgenom ohmyzsh plugins/brew

	# If zsh-syntax-highlighting is bundled after zsh-history-substring-search,
  	# they break, so get the order right.
  	zgenom load zdharma-continuum/fast-syntax-highlighting
  	zgenom load zsh-users/zsh-history-substring-search

	# Autosuggestions
	zgenom load zsh-users/zsh-autosuggestions

	# Miscellaneous utility functions
	zgenom load unixorn/jpb.zshplugin

	# Colorize
	zgenom load unixorn/warhol.plugin.zsh

	# macOS helpers -- plugin automatically doesn't load outside macOS
	zgenom load unixorn/tumult.plugin.zsh

	# Apple DNS sucks
	zgenom load eventi/noreallyjustfuckingstopalready

	# Warn when you run a command that has an alias
	zgenom load djui/alias-tips

	# History search with fzf
	zgenom load unixorn/fzf-zsh-plugin

	zgenom load chrissicool/zsh-256color

	# Load more completion files for zsh from zsh-lovers
	zgenom load zsh-users/zsh-completions src

	# Docker completions
	zgenom load srijanshetty/docker-zsh

	# Powerlevel10k
	zgenom load romkatv/powerlevel10k powerlevel10k

	# Better ctrl-R
	zgenom load zdharma-continuum/history-search-multi-word
		
	# Tab titles
	zgenom load trystan2k/zsh-tab-title

	zgenom save
fi

source $ZDOTDIR/config.zsh
if [[ $TERM != dumb ]]; then
  source $ZDOTDIR/keybinds.zsh
  source $ZDOTDIR/completion.zsh
  source $ZDOTDIR/aliases.zsh

  function _cache {
    command -v "$1" >/dev/null || return 1
    local cache_dir="$XDG_CACHE_HOME/${SHELL##*/}"
    local cache="$cache_dir/$1"
    if [[ ! -f $cache || ! -s $cache ]]; then
      echo "Caching $1"
      mkdir -p $cache_dir
      "$@" >$cache
    fi
    source $cache || rm -f $cache
  }

  # use fd instead of find if installed
  if command -v fd >/dev/null; then
    export FZF_DEFAULT_COMMAND="fd ."
    export FZF_CTRL_H_COMMAND="fd -t d . $HOME"
  fi

  
  # To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
  [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
fi


# source host-local configuration
[ -f ~/.zshrc ] && source ~/.zshrc

# dedupe path
typeset -aU path;
