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

my_zsh_zplug() {
  # Check if zplug is installed
  if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/init.zsh && zplug update --self
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

  export ZSH_PLUGINS_ALIAS_TIPS_TEXT='💡 '
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

  # Additional completion definitions for Zsh
  zplug "zsh-users/zsh-completions",              defer:2
  zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
  zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-history-substring-search", defer:3, on:"zsh-users/zsh-syntax-highlighting"

  zstyle ':prezto:module:utility:ls'    color 'yes'
  zstyle ':prezto:module:utility:diff'  color 'yes'
  zstyle ':prezto:module:utility:wdiff' color 'yes'
  zstyle ':prezto:module:utility:make'  color 'yes'

  zstyle ':prezto:module:tmux:auto-start' local  'yes'
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

### THEME ###

#THEME=base16-monokai.dark
#source $HOME/projects/other/base16-shell/$THEME.sh

## PLUGINS
my_zsh_zplug

## ZSH CONFIG
setopt append_history
setopt hist_expire_dups_first
setopt hist_fcntl_lock
setopt hist_ignore_all_dups
setopt hist_lex_words
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt share_history

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

#complete
fpath=(/usr/local/share/zsh-completions $fpath)

# show fortune cookie
type fortune &>/dev/null && fortune -a

# added by travis gem
[ -f /Users/chcha/.travis/travis.sh ] && source /Users/chcha/.travis/travis.sh


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
