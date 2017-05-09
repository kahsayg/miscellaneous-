#!/bin/bash

#SBATCH --job-name=RCS0416_hello
#SBATCH --account=
#SBATCH --time=00:00:10
#SBATCH --mem-per-cpu=256M

source /cluster/bin/jobsetup

echo "Hello from Abel"

