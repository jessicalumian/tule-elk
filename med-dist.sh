#!/bin/bash --login
#PBS -l walltime=6:00:00
#PBS -l mem=200gb
#PBS -l nodes=1:ppn=8
#PBS -m abe
#PBS -N elk-abund-count-2
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules
module use /opt/software/ged-software/modulefiles/
module load anaconda
source activate elk
module swap GNU GNU/4.9

pip install -U setuptools
git clone https://github.com/dib-lab/khmer.git
cd khmer
make install

khmer/sandbox/calc-median-distribution.py reads.kh final.contigs.fa reads-cov.dist



cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
