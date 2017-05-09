#!/bin/bash

#SBATCH --job-name=RCS1115_hello
#SBATCH --account=staff
#SBATCH --time=00:10:00
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=2G

source /cluster/bin/jobsetup
set -o errexit

arrayrun 1-3 array_test.slurm
