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
  export ZPLUG_HOME=~/.zplug

  if [[ ! -d ~/.zplug ]]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    source ~/.zplug/init.zsh && zplug update
  fi

  source ~/.zplug/init.zsh
  # zplug "mollifier/anyframe"
  # zplug "b4b4r07/enhancd", use:init.sh
  # Vanilla shell
  # zplug "yous/vanilli.sh"
  # Load if "if" tag returns true
  zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"


  # Additional completion definitions for Zsh
  zplug "zsh-users/zsh-completions"
  zplug "felixr/docker-zsh-completion"

  # Syntax highlighting bundle. zsh-syntax-highlighting must be loaded after
  # excuting compinit command and sourcing other plugins.
  zplug "zsh-users/zsh-syntax-highlighting"
  # ZSH port of Fish shell's history search feature
  #zplug "zsh-users/zsh-history-substring-search"

  # Load the theme.
  zplug "yous/lime", as:theme
  #zplug 'dracula/zsh', as:theme

  export ZSH_PLUGINS_ALIAS_TIPS_TEXT='💡 '

  # fix garish, unreadable green and yellow node segment colours
  POWERLEVEL9K_NODE_VERSION_BACKGROUND="red"
  POWERLEVEL9K_NODE_VERSION_FOREGROUND="white"

  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time $TOOL_VERSION)
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  POWERLEVEL9K_SHORTEN_DELIMITER=""
  POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

  zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

  zplug "thewtex/tmux-mem-cpu-load"

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi

  # Then, source plugins and add commands to $PATH
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

BULLETTRAIN_CONTEXT_SHOW=true
BULLETTRAIN_IS_SSH_CLIENT=true

BULLETTRAIN_PROMPT_ORDER=(
  time
  dir
  git
  context
)

my_zsh_zplug

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# show fortune cookie
type fortune &>/dev/null && fortune -a

# added by travis gem
[ -f /Users/chcha/.travis/travis.sh ] && source /Users/chcha/.travis/travis.sh


