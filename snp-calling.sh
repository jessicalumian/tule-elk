#!/bin/bash --login
#PBS -l walltime=168:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -N elk-snp-calling
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

# samtools to call snps
samtools mpileup -uD -f final.contigs.fa all-interleaved-elk-reads.sorted.bam | bcftools view -bvcg - > elk-snps.raw.bcf

# convert BCF to VCF
bcftools view elk-snps.raw.bcf > elk-snps.vcf

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
