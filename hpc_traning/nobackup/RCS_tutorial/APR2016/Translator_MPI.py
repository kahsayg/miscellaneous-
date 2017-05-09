#!/usr/bin/python
#Translater.py
import sys 
#To read in command line arguments
import string
#To do this in parallel
from mpi4py import MPI
comm = MPI.COMM_WORLD

def main(argv):
 #Which thread is it
 rank = comm.Get_rank()  
 #How many thread are there in total
 no_of_ranks = comm.Get_size()

 if(len(sys.argv) == 3):  #first argument is always script 
  lines_per_rank=get_lines_per_trank(sys.argv[2],no_of_ranks)
  print "no_of_ranks=", no_of_ranks," rank=", rank, "lines_per_rank=",lines_per_rank
  content =[]
  with open(sys.argv[1], "r") as f:
   for i, line in enumerate(f):
    #The first chunk, if it is the
    if(rank == 0 and i < lines_per_rank):
     content.append(line)
    #If it is the last thread everything left
    elif(rank == (no_of_ranks-1) and (i>(lines_per_rank*(rank)))):
     content.append(line)
    elif((i > (rank*lines_per_rank)) and (i <= ((rank + 1)*lines_per_rank))):
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
  print "Usage:"+sys.argv[0] +" <Filetoprocess> <NUMBEROFLINESFILES"

def get_lines_per_trank(size_file, no_of_ranks):
 #Number of lines to read, this is calculated externally to simplify
 #Here we are reading it from file
 lines_per_rank=0 
 with open(size_file, "r") as f2:
   for i, line in enumerate(f2):
    number_of_lines=line
    lines_per_rank=(int(number_of_lines)/no_of_ranks)
 if(lines_per_rank < 1 ):
  lines_per_rank=1
 return lines_per_rank

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
