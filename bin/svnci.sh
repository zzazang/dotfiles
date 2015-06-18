#!/bin/sh

CWD=$(pwd)
HOST_SRC=$(find src/ -name 'nf_webra*.[ch]')
WEBRA_SRC="webra_anf"

if [ -f "run_ipx.sh" ];
then
  echo "Commiting $HOST_SRC $WEBRA_SRC $1"
  svn ci $HOST_SRC $WEBRA_SRC $1
else
  echo "NOT NFHOST DIR"
fi

