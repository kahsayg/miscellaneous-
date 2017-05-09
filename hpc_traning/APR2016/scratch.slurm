#!/bin/bash

#SBATCH --job-name=RCS0416_usescratch
#SBATCH --account=xxx
#SBATCH --time=00:00:15
#SBATCH --mem-per-cpu=1G
#SBATCH --ntasks=1

source /cluster/bin/jobsetup
set -o errexit

echo $SUBMITDIR
echo $SCRATCH
cp $SUBMITDIR/input* $SCRATCH
chkfile output.txt
cat input* > output.txt
