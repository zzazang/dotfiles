#!/bin/sh

ABSOLUTEPATH=
REBUILD_FILES=
TAGSFILES=

function mkfiles
{
  if [ "$REBUILD_FILES" = "1" ]; then
    ## rebuild 모드로 동작한다.
    rm -f cscope.files > /dev/null
  fi

  ## cscope.files 파일이 존재하지 않으면 검색할 파일의 리스트를 새롭게
  ## cscope.files로 저장한다.
  if [ ! -f cscope.files ]; then
    if [ "$ABSOLUTEPATH" = "1" ]; then
      CWD=`pwd`
    else
      CWD=.
    fi

    echo "Rebuild files list in [$CWD]..."
    find -L $CWD \( -name .svn -o -name CVS \) -prune -o \
      \( \
      -name '*.[ch]pp' -o \
      -name '*.[CH]PP' -o \
      -name '*.[CcHhSsMm]' -o \
      -name '*.htm' -o -name '*.html' -o \
      -name '*.js' -o \
      -name '*.java' \
      \) \
      -print > cscope.files
  fi

  ## 만약 cscope.files의 size가 0이라면 대상 파일이 존재하지 않는 것이다.
  if [ ! -s cscope.files ];then
    echo "Target files are not exist..."
    rm -f cscope.files
    exit 1
  fi

}

function mkcscope
{
  rm -f cscope.out 2> /dev/null

  ## file list로부터 cscope database 파일을 생성한다.
  ## cscope 파일을 일단 실행해 보고, cscope 파일이 존재하는지를 check한다.
  echo "Making CSCOPE and CTAGS database files ..."
  CSCOPE=`which cscope 2> /dev/null`
  if [ $CSCOPE"A" != "A" ];then
    cscope -U -b -i cscope.files
  else
    echo "[WARNING] cscope isn't exist."
  fi
}

function mktags
{
  rm -f tags 2> /dev/null

  if [ "$TAGSFILES" = "1" ]; then
    ## file list로부터 ctags database 파일을 생성한다.
    ctags -L cscope.files
  else
    ctags --langmap=C++:+.inc+.def --c++-kinds=+p --fields=+iaS --extra=+fq --sort=foldcase -R .
  fi
}

while getopts "afr" OPTION;
do
  case $OPTION in
    "a")
      # use absolute path
      ABSOLUTEPATH=1
      ;;
    "r")
      # rebuild files
      REBUILD_FILES=1
      ;;
    "f")
      # make tags using cscope.files
      TAGSFILES=1
      ;;
  esac
done

mkfiles
mkcscope
mktags

echo "done.."

