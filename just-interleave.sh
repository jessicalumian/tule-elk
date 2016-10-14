#!/bin/bash --login
#PBS -l walltime=8:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -N elk-interleaving
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

## INTERLEAVING READS

for filename in ../*_R1_*.fastq.gz
do
     # first, make the base by removing .fastq.gz
     base=$(basename $filename .fastq.gz)
     echo $base

     # now, construct the R2 filename by replacing R1 with R2
     baseR2=${base/_R1_/_R2_}
     echo $baseR2

     # construct the output filename
     output=${base/_R1_/}.fastq.gz

     (interleave-reads.py ../${base}.fastq.gz ../${baseR2}.fastq.gz --gzip)

done


cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
