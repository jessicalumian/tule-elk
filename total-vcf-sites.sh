#!/bin/bash --login
#PBS -l walltime=4:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -N het-counting
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

# NOTE - STILL NEED TO WRITE SCRIPT
#for i in *min2.vcf
do
 echo ${i} >> het-counts.txt
 grep -c "0/1" ${i} >> het-counts.txt

done

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
