#!/bin/bash --login
#PBS -l walltime=60:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -N elk-mapping
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

# index reference genome
bwa index final.contigs.fa

### ELK 2919 ###

## MAPPING ##

# map raw reads from 2919 to reference genome
bwa mem final.contigs.fa ../2919-INSERT-FILE-NAME-HERE.gz > 2919-elk-reads.sam

# index reference genome with samtools
samtools faidx final.contigs.fa

# convert sam to bam
samtools import contigs.fa.fai 2919-elk-reads.sam 2919-elk-reads.bam

# sort the bam file
samtools sort 2919-elk-reads.bam 2919-elk-reads.sorted

# index the sorted bam file
samtools index 2919-elk-reads.sorted.bam

## SNP CALLING ##

freebayes -f final.contigs.fa --ploidy 2 --min-coverage 10 --no-mnps --no-complex --min-alternate-count 3 2919-elk-reads.sorted.bam | vcffilter -f "QUAL > 20" > 2919-elk-snps.vcf


### ELK 2920 ###

## MAPPING ##

# map raw reads from 2920 to reference genome
bwa mem final.contigs.fa ../2920-INSERT-FILE-NAME-HERE.gz > 2920-elk-reads.sam

# convert sam to bam
samtools import contigs.fa.fai 2920-elk-reads.sam 2920-elk-reads.bam

# sort the bam file
samtools sort 2920-elk-reads.bam 2920-elk-reads.sorted

# index the sorted bam file
samtools index 2920-elk-reads.sorted.bam

## SNP CALLING ##

freebayes -f final.contigs.fa --ploidy 2 --min-coverage 10 --no-mnps --no-complex --min-alternate-count 3 2920-elk-reads.sorted.bam | vcffilter -f "QUAL > 20" > 2919-elk-snps.vcf


### ELK 1339 ###

## MAPPING ##

# map raw reads from 1339 to reference genome
bwa mem final.contigs.fa ../1339-INSERT-FILE-NAME-HERE.gz > 1339-elk-reads.sam

# convert sam to bam
samtools import contigs.fa.fai 1339-elk-reads.sam 1339-elk-reads.bam

# sort the bam file
samtools sort 1339-elk-reads.bam 1339-elk-reads.sorted

# index the sorted bam file
samtools index 1339-elk-reads.sorted.bam

## SNP CALLING ##

freebayes -f final.contigs.fa --ploidy 2 --min-coverage 10 --no-mnps --no-complex --min-alternate-count 3 1339-elk-reads.sorted.bam | vcffilter -f "QUAL > 20" > 1339-elk-snps.vcf


### ELK 1351 ###

## MAPPING ##

# map raw reads from 1351 to reference genome
bwa mem final.contigs.fa ../1351-INSERT-FILE-NAME-HERE.gz > 1351-elk-reads.sam

# convert sam to bam
samtools import contigs.fa.fai 1351-elk-reads.sam 1351-elk-reads.bam

# sort the bam file
samtools sort 1351-elk-reads.bam 1351-elk-reads.sorted

# index the sorted bam file
samtools index 1351-elk-reads.sorted.bam

## SNP CALLING ##

freebayes -f final.contigs.fa --ploidy 2 --min-coverage 10 --no-mnps --no-complex --min-alternate-count 3 1351-elk-reads.sorted.bam | vcffilter -f "QUAL > 20" > 1351-elk-snps.vcf


cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
