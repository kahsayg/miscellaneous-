#!/bin/bash

#SBATCH --job-name=MPI_test
#SBATCH --account=staff
#SBATCH --time=00:10:00
#SBATCH	--mem-per-cpu=6G
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=1

source /cluster/bin/jobsetup
set -o errexit

echo $JOBID

TRANSLATOR=Translator_MPI.py
INPUTFILE=$1
OUTPUTFILE=$1_trans
chkfile  $OUTPUTFILE

time cp $INPUTFILE $SCRATCH/
cp $TRANSLATOR $SCRATCH/
cd $SCRATCH/

head -10 /var/spool/slurmd/job$SLURM_JOBID/slurm_script
echo "___________________________________"

module load openmpi.gnu/1.8.8
module load python2

wc -l $INPUTFILE | awk '{print $1}'> LINECOUNT.TXT

cat .chkfiles
/usr/bin/time -v  mpirun -n 2 python2 $TRANSLATOR $INPUTFILE LINECOUNT.TXT
#/usr/bin/time -v python2 $TRANSLATOR $INPUTFILE LINECOUNT.TXT

ls -lhrt t*
cat t_* > $OUTPUTFILE
cat .chkfiles
