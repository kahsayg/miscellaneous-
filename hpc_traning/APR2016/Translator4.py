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
  print "Usage:"+ sys.argv[0]+" <Filetoprocess>"

def translate(content):
 transformer ={"A":"Q","T":"A","Q":"T","G":"R","C":"G","R":"C"}
 keyl= ["A","T","Q","G","C","R"]
 output = []
 for line in content:
   line=line.upper()
   for key in keyl:
    line = string.replace(line,key, transformer[key])
   output.append(line)
 return output 


if __name__ == "__main__":
   main(sys.argv)
