#!/bin/bash
CARROTS=10
HORSES=8
if test $CARROTS -ge $HORSES
then
 echo "There are enough carrots"
else
 echo "Warning: Not enough carrots!"
 SADHORSES=$(expr $HORSES - $CARROTS)
 echo "$SADHORSES horses will not get a carrot."
fi

