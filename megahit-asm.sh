#!/bin/bash --login
#PBS -l walltime=60:00:00
#PBS -l mem=200gb
#PBS -l nodes=1:ppn=8
#PBS -m abe
#PBS -N elk-megahit-full-asm
#PBS -A ged

cd ${PBS_O_WORKDIR}

# runs megahit on full dataset, not diginormed
../intermediate/megahit/megahit --12 ../intermediate/all-interleaved-elk-reads.pe.qc.fq.gz -o ../intermediate/megahit_out

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
