export EDITOR=vim

alias vi='/usr/bin/vim'

export PYTHONPATH=/usr/lib/python2.7/site-packages

#export GREP_COLOR='1;33'
#export GREP_OPTIONS="--color=auto --exclude-dir='.svn*' --exclude=cscope* --exclude=tags"

alias svndiff='(echo "Running SVN diff (your changes vs. the repo)..." && (svn -x -w diff|colordiff))|less -R'
alias svnbasediff='(echo "Running SVN diff against BASE:HEAD (changes in the repo since last \"svn update\")..." && (svn diff -x -w -rBASE:HEAD|colordiff))|less -R'

alias ydiff='y_diff'
function y_diff() {
  diff --width=${COLUMNS} -b -y "$1" "$2" | colordiff | less -R
}

