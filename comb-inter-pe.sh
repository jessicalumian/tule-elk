#!/bin/bash --login
#PBS -l walltime=04:00:00
#PBS -l mem=200gb
#PBS -l nodes=1:ppn=8
#PBS -m abe
#PBS -N comb-inter-pe-reads-cor
#PBS -A ged

cd ${PBS_O_WORKDIR}

## RUN ASSEMBLIES AT MULTIPLE K ##

source hpcc.modules

# rm -fr ../intermediate/all-interleaved-elk-reads.pe.qc.fq.gz

cat ../intermediate/*.pe.trim.qc.fq.gz > ../intermediate/all-interleaved-elk-reads.pe.qc.fq.gz

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
