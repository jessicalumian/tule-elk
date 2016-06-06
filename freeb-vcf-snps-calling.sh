#!/bin/bash --login
#PBS -l walltime=168:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -N freeb-snp-calling
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

freebayes -f final.contigs.fa --ploidy 2 --min-coverage 10 --no-mnps --no-complex --min-alternate-count 3 all-interleaved-elk-reads.sorted.bam | vcffilter -f "QUAL > 20" > freeb-elk-snps.vcf

## file from Zach Lounsberry

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
