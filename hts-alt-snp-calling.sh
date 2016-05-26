#!/bin/bash --login
#PBS -l walltime=168:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -N elk-snps-hts
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

samtools mpileup -ugf final.contigs.fa all-interleaved-elk-reads.sorted.bam | bcftools call -vmO z -o elk-snps.vcf.gz

gunzip elk-snps.vcf.gz

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
