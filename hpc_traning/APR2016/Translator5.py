#!/usr/bin/python
#Translater.py
import sys #To read in command line arguments
import string

def main(argv):
 if(len(sys.argv) == 2):  #first argument is always script 
  print "length ok"
  content =[]
  with open(sys.argv[1], "r") as f:
   for i, line in enumerate(f):
    content.append(line)
  if(len(content)>0):
   #Call translate function 
   output = translate(content)
   #Write to a new file
   if(len(output)>0):
    outfile = open("t_"+sys.argv[1], 'w')
    for tlines in output:
     outfile.write(tlines)
    print "file written "+"t_"+sys.argv[1]  
   else:
    print "Nothing to write"
  else:
   print "Nothing read" 
 else:
  print "Usage:"+sys.argv[0] +" <Filetoprocess>"

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
