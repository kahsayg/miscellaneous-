#!/bin/bash

WHO=All

if [ $# -gt 0 ]
then
  WHO=$1
fi

DATE=$(date)
echo "Welcome '$WHO' to RCS Course Week\n$DATE"
