#!/usr/bin/python
#Translater.py
import sys #To read in command line arguments
import string

def main(argv):
 if(len(sys.argv) == 2):  #first argument is always script 
  content =[]
  with open(sys.argv[1], "r") as f:
   for i, line in enumerate(f):
    content.append(line)
  if(len(content)>0):
   print "Content read" 
   print translate(content) 
  else:
   print "Nothing read" 
 else:
  print "Usage: Translater3.py <Filetoprocess>"

def translate(content):
 output = []
 for line in content:
   line=line.upper()
   tline = string.replace(line, 'A', 'Q')
   tline = string.replace(tline, 'T', 'A')
   tline = string.replace(tline, 'Q', 'T')
   tline = string.replace(tline, 'G', 'Q')
   tline = string.replace(tline, 'C', 'G')
   tline = string.replace(tline, 'Q', 'C')
   output.append(tline)
 return output

if __name__ == "__main__":
   main(sys.argv)
