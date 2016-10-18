#!/bin/bash --login
#PBS -l walltime=8:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -N elk-interleaving
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules
module use /opt/software/ged-software/modulefiles/
module load anaconda
source activate elk
module swap GNU GNU/4.9

## INTERLEAVING READS

for filename in /mnt/research/ged/jessica/elk/*_R1_*.fastq.gz
do
     # first, make the base by removing .fastq.gz
     base=$(basename $filename .fastq.gz)
     echo $base

     # now, construct the R2 filename by replacing R1 with R2
     baseR2=${base/_R1_/_R2_}
     echo $baseR2

     # construct the output filename
     output=${base/_R1_/}.fastq.gz

     (interleave-reads.py /mnt/research/ged/jessica/elk/${base}.fastq.gz /mnt/research/ged/jessica/elk/${baseR2}.fastq.gz --gzip)

done

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
