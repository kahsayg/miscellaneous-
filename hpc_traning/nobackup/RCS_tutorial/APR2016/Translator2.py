#!/usr/bin/python
#Translater.py
import sys #To read in command line arguments
import string
output = []

def main(argv):
 if(len(sys.argv) == 2):  #first argument is always script 
  content =[]
  with open(sys.argv[1], "r") as f:
   for i, line in enumerate(f):
    content.append(line)
  if(len(content)>0):
   print "Content read" 
  else:
   print "Nothing read" 
 else:
  print "Usage:python Translator2.py <Filetoprocess>"

if __name__ == "__main__":
   main(sys.argv)
