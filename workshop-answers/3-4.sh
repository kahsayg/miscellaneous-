#!/bin/bash

if [ ! $1 ]
 then
  echo "Usage: $(basename $0) <filename>"
  exit
fi

if ! [ -f $1 ]
 then
  echo "Error: file $1 not found"
  exit 1
fi

for NAME in $(cat $1)
 do
  echo "Hello $NAME!"
 done
