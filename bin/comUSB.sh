#!/bin/sh

#ssterm -b 115200 /dev/ttyUSB0

DEFAULT_PORT=20000

if [ "$1" -gt 0 -o "$1" -le 9 ]
then
  PORT=$(($DEFAULT_PORT+$1))
else
  PORT=20001
fi

echo "Connecting to $PORT"

telnet localhost $PORT

