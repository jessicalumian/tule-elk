#!/bin/bash --login
#PBS -l walltime=20:00:00
#PBS -l mem=100gb
#PBS -l nodes=1:ppn=8
#PBS -m abe
#PBS -N elk-full-diginorm
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules
module use /opt/software/ged-software/modulefiles/
module load anaconda
source activate elk
module swap GNU GNU/4.9

normalize-by-median.py -k 20 -C 20 -N 4 -x 2e8 -s normC20k20.ct ../intermediate/*.pe.trim.qc.fq.gz

filter-abund.py -V normC20k20.ct ../intermediate/*.keep

for filename in ../intermediate/*.pe.*.keep.abundfilt
do
   extract-paired-reads.py ../intermediate/$filename
done

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
