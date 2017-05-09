#!/bin/bash

#SBATCH --job-name=RCS0416_hello
#SBATCH --account=staff
#SBATCH --time=00:01:05
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=256M

source /cluster/bin/jobsetup
set -o errexit

cp  $SUBMITDIR/input.txt $SCRATCH
EXTENTION=".txt"
RESULT=$TASK_ID$EXTENTION
chkfile $RESULT 

python array_test.py input.txt $RESULT $TASK_ID

