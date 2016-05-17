#!/bin/bash --login
#PBS -l walltime=168:00:00
#PBS -l mem=600gb
#PBS -l nodes=1:ppn=8
#PBS -m abe
#PBS -N elk-abund-count
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules
module use /opt/software/ged-software/modulefiles/
module load anaconda
source activate elk
module swap GNU GNU/4.9

load-into-counting.py -x 15e9 -N 4 -k 20 reads.kh final.contigs.fa
abundance-dist.py -s reads.kh final.contigs.fa reads.dist


cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
