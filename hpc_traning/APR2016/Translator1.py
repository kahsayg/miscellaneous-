#!/usr/bin/python
#Translater.py
import sys #To read in command line arguments
import string
output = []
if(len(sys.argv) == 2):  #first argument is always script 
 with open(sys.argv[1], "r") as f:
    content =[]
    for i, line in enumerate(f):
      content.append(line)
 if(len(content)>0):
   print "Content read"
 else:
   print "Nothing read"
else:
 print "Usage: python Translator1.py <INPUT_FILE>"
