#!/bin/bash
flagfile=flag.bin
if [ $# -lt 1 ]; then
  echo "Usage: $0 [-f] device"
  echo 
  exit
fi
if [ $# -gt 1 ]; then
  if [ "$1" == "-f" ]; then
     force=1
     shift
  else
     echo "Usage: $0 [-f] device"
     echo
     exit
  fi
fi

if [ ! -f $flagfile ]; then
  echo -n -e '\x55\xAA' > $flagfile
fi
if [ ! -b $1 ]; then
  if [ "$force" != "1" ]; then
    echo "Error: $1 is not a block device."
    echo
    exit
  fi
fi
dd if=$flagfile of=$1 bs=1 seek=510 count=2
