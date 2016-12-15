#!/bin/bash --login
#PBS -l walltime=68:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -N snp-counting
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

for i in *.vcf
do
 echo ${i} >> elk-snp-counts.txt
 grep k ${i} | wc -l >> elk-snp-counts.txt

done

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
