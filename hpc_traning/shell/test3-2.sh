 #!/bin/bash

if [ $# -gt 0 ]
then
    
 for name in "$(cat $1)"
 do 
 echo $name
 done 
 
fi 
    