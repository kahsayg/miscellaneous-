#!/bin/bash

if [ $# -gt 0 ]
then 
    name="$1"
    var="hello"
   
    if [ $name=="Alice" ]||[ $name=="boob"]
    then
	echo $var $name 
    else 
	echo $var
    fi
    
fi
    
