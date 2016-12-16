#!/bin/bash --login
#PBS -l walltime=68:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -N read-counting
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

for i in ../*.fastq.gz
do

  echo "$i" >> elk-read-counting-correct.txt
  echo "number of lines:" >> elk-read-counting-correct.txt
  zcat ${i} | wc -l >> elk-read-counting-correct.txt

done

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
