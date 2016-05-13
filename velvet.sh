#!/bin/bash --login
#PBS -l walltime=50:00:00
#PBS -l mem=600gb
#PBS -l nodes=1:ppn=8
#PBS -m abe
#PBS -N elk-full-asm
#PBS -A ged

cd ${PBS_O_WORKDIR}

## RUN ASSEMBLIES AT MULTIPLE K ##

source hpcc.modules

rm -fr intermediate/all-interleaved-elk-reads.pe.trim.qc.fq.gz

zcat intermediate/*.pe.trim.qc.fq.gz > intermediate/all-interleaved-elk-reads.pe.qc.fq.gz
mkdir -p output

export OMP_NUM_THREADS=8
export OMP_THREAD_LIMIT=8

for k in {23..27..2};
do
    velveth output/velvet-output.$k.d $k -fastq.gz -shortPaired intermediate/all-interleaved-elk-reads.pe.qc.fq.gz && \
    velvetg output/velvet-output.$k.d -exp_cov auto -cov_cutoff auto
done


cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
