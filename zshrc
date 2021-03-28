if [[ "$ZPROF" = true ]]; then
  zmodload zsh/zprof
fi

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

load_utilities() {
  test_file_exists() { [[ -f $1 ]] }
  test_dir_exists() { [[ -d $1 ]] }
  test_executable() { [[ -x $1 ]] }
  test_readable() { [[ -r $1 ]] }
  test_command_exists() { type "$1" >/dev/null 2>&1 }
  test_null() { [[ -z $1 ]] }
  test_not_null() { [[ -n $1 ]] }
  on_osx() { [[ $(uname) == "Darwin" ]] }
  on_linux() { [[ $(uname) == "Linux" ]] }
}

my_zsh_plugin_config() {
  ### POWERLEVEL9K
  ## fix garish, unreadable green and yellow node segment colours
  POWERLEVEL9K_NODE_VERSION_BACKGROUND="red"
  POWERLEVEL9K_NODE_VERSION_FOREGROUND="white"

  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time $TOOL_VERSION)
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  POWERLEVEL9K_SHORTEN_DELIMITER=""
  POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
  POWERLEVEL9K_MODE='nerdfont-complete'

  autoload -Uz compinit
  if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
    compinit -i
  else
    compinit -C -i
  fi

  zmodload -i zsh/complist

  zstyle ':prezto:module:utility:ls'    color 'yes'
  zstyle ':prezto:module:utility:diff'  color 'yes'
  zstyle ':prezto:module:utility:wdiff' color 'yes'
  zstyle ':prezto:module:utility:make'  color 'yes'

  zstyle ':prezto:module:tmux:auto-start' local  'no'
  zstyle ':prezto:module:tmux:auto-start' remote 'yes'

  zstyle ':completion:*' rehash true
  zstyle ':completion:*' verbose yes
  zstyle ':completion:*:descriptions' format '%B%d%b'
  zstyle ':completion:*:messages' format '%d'
  zstyle ':completion:*:warnings' format 'No matches for: %d'
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*:*:docker:*' option-stacking yes
  zstyle ':completion:*:*:docker-*:*' option-stacking yes
}

my_zsh_zplugin() {
  source ~/.zplugin/bin/zplugin.zsh

  zplugin "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

  zplugin snippet PZT::modules/tmux/init.zsh
  zplugin snippet PZT::modules/history/init.zsh
  zplugin snippet PZT::modules/utility/init.zsh
  zplugin snippet PZT::modules/ruby/init.zsh
  zplugin snippet PZT::modules/ssh/init.zsh
  zplugin snippet PZT::modules/terminal/init.zsh
  zplugin snippet PZT::modules/direcry/init.zsh
  zplugin snippet PZT::modules/completion/init.zsh
}

dynamic_my_zsh_antibody() {
  source <(antibody init)
  antibody bundle < ~/.zsh_plugins.txt
}

my_zsh_antibody() {
  source ~/.zsh_plugins.sh
}


my_zsh_plugin_zgen() {
  # load zgen
  source "${HOME}/.zgen/zgen.zsh"

  # if the init script doesn't exist
  if ! zgen saved; then
    # specify plugins here
    zgen oh-my-zsh
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh themes/arrow
    zgen oh-my-zsh compleat
    zgen load romkatv/powerlevel10k powerlevel10k

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen oh-my-zsh themes/arrow

    # generate the init script from plugins above
    zgen save
  fi
}

my_zsh_zplug() {
  # Check if zplug is installed
  export ZPLUG_HOME=~/.zplug

  if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    source ~/.zplug/init.zsh && zplug update
  fi

  source ~/.zplug/init.zsh

  ##### theme
  ## Pure theme (zsh-async is required by pure)
  # zplug "mafredri/zsh-async", from:github
  # zplug "sindresorhus/pure", use:"pure.zsh", as:theme

  ### POWERLEVEL9K
  ## fix garish, unreadable green and yellow node segment colours
  POWERLEVEL9K_NODE_VERSION_BACKGROUND="red"
  POWERLEVEL9K_NODE_VERSION_FOREGROUND="white"

  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time $TOOL_VERSION)
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  POWERLEVEL9K_SHORTEN_DELIMITER=""
  POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
  POWERLEVEL9K_MODE='nerdfont-complete'

  zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

  ##### plugins
  zplug "modules/tmux",       from:prezto
  zplug "modules/history",    from:prezto
  zplug "modules/utility",    from:prezto
  zplug "modules/ruby",       from:prezto
  zplug "modules/ssh",        from:prezto
  zplug "modules/terminal",   from:prezto
  zplug "modules/directory",  from:prezto
  zplug "modules/completion", from:prezto

  zplug "supercrabtree/k"
  #zplug "thewtex/tmux-mem-cpu-load"

  # Additional completion definitions for Zsh
  zplug "zsh-users/zsh-completions",              defer:2
  zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
  zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-history-substring-search", defer:3, on:"zsh-users/zsh-syntax-highlighting"

  zstyle ':prezto:module:utility:ls'    color 'yes'
  zstyle ':prezto:module:utility:diff'  color 'yes'
  zstyle ':prezto:module:utility:wdiff' color 'yes'
  zstyle ':prezto:module:utility:make'  color 'yes'

  zstyle ':prezto:module:tmux:auto-start' local  'no'
  zstyle ':prezto:module:tmux:auto-start' remote 'yes'

  zstyle ':completion:*' rehash true
  zstyle ':completion:*' verbose yes
  zstyle ':completion:*:descriptions' format '%B%d%b'
  zstyle ':completion:*:messages' format '%d'
  zstyle ':completion:*:warnings' format 'No matches for: %d'
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*:*:docker:*' option-stacking yes
  zstyle ':completion:*:*:docker-*:*' option-stacking yes

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi

  # Then, source plugins and add commands to $PATH
  #zplug load --verbose
  zplug load
  setopt monitor
}

load_utilities

#####################################################################
# environment
#####################################################################

export EDITOR=vim
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=''
export PAGER=less
export MANPAGER='less -X'
export LESSCHARSET=utf-8
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export PATH=$HOME/bin:$PATH

# show fortune cookie
type fortune &>/dev/null && fortune|cowsay -f tux -n|lolcat

## PLUGINS
my_zsh_plugin_config
#my_zsh_antibody
#my_zsh_zplug
#my_zsh_zplugin
my_zsh_plugin_zgen
#source ~/.zsh_plugins.sh

## ZSH CONFIG
setopt append_history
setopt hist_expire_dups_first
setopt hist_fcntl_lock
setopt hist_ignore_all_dups
setopt hist_lex_words
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt no_share_history

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

#complete
fpath=(/usr/local/share/zsh-completions $fpath)

# Google Cloud SDK.
if [[ -x "$(command -v gcloud)" ]]; then
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

## Kubernetes
#if [[ -x "$(command -v kubectl)" ]]; then
#  source <(kubectl completion zsh)
#fi
#
##helm
#if [[ -x "$(command -v helm)" ]]; then
#  source <(helm completion zsh)
#fi
#
# Go
if [[ -x "$(command -v go)" ]]; then
  GOROOT="/usr/local/opt/go/libexec/bin"
  export GOPATH="$HOME/.go"
  export PATH=$PATH:$GOROOT:$GOPATH/bin
fi

# added by travis gem
[ -f /Users/chcha/.travis/travis.sh ] && source /Users/chcha/.travis/travis.sh

#fpath=(/Users/chassi/.zsh/gradle-completion $fpath)

export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

if [[ "$ZPROF" = true ]]; then
  zprof
fi

