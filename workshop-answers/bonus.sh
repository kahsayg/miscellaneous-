#!/bin/bash

# Long version of the "99 Bottles" challenge
# with comments for clarity.
#
# For the Research Computing Services course week
# By: Andreas Buzh Skau <buzh@usit.uio.no>
# Spring 2016

# Store lyrics in variables to avoid duplicating text:
b="bottles of beer"
w="on the wall"
t="Take one down and pass it around,"
o="o more"

# Count down from 99 to 2 using brace expansion
# {1..3} expands to 1 2 3. Try "echo {1..3}" to see

for n in {99..2}
 do
# echo -e interprets \n to be a line break, \t to be a tab etc.
  echo -e "$n $b $w,\n$n $b.\n$t\n$(($n -1 )) $b $w.\n"
 done

# handle the special case of the last two verses
echo -e "1 $b $w,\n1 $b.\n$t\nN$o $b $w.\n\nN$o $b $w,\nn$o $b.\nGo to the store and buy some more,\n99 $b $w."
