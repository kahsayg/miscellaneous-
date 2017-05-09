import re
import sys

inputfile  = sys.argv[1]
outputfile = sys.argv[2]
taskid = sys.argv[3]
 
with open(inputfile, 'r') as f:
 read=""
 for line in f:
    read= read + line +"\n"
 f.close
 with open(outputfile, 'w') as f2:
   f2.write(read + taskid)
   f2.close
	
