#!/bin/bash

#SBATCH --job-name=RCS0416_hello
#SBATCH --account=xx
#SBATCH --time=00:00:05
#SBATCH --mem-per-cpu=256M
#SBATCH --mail-type=ALL
#SBATCH --mail-user=


source /cluster/bin/jobsetup

set -o errexit

echo "Hello2 from Abel"

