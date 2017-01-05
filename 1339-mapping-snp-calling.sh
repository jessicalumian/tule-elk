#!/bin/bash --login
#PBS -l walltime=150:00:00
#PBS -l mem=600gb
#PBS -m abe
#PBS -N 1339-dup-removal
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

### ELK 1339 ###

## MAPPING ##

# map raw reads from 1339 to reference genome
#bwa mem /mnt/research/ged/jessica/elk/working-scripts/final.contigs.fa /mnt/research/ged/jessica/elk/interleaved-reads/S15-1339_S82_L007_R1_001.fastq.gz > 1339-elk-reads.sam

# convert sam to bam
#samtools import /mnt/research/ged/jessica/elk/working-scripts/contigs.fa.fai 1339-elk-reads.sam 1339-elk-reads.bam

## NEW SECTION - REMOVING CLONES ##

# mark duplicates based on start and end position of reads
java -jar $PICARD/MarkDuplicates.jar I=1339-elk-reads.bam O=1339_nodup.bam M=Metrics

# remove duplicates from paired end reads ( -S flag for unpaired)
samtools rmdup 1339_nodup.bam > 1339-nodup.bam

# prints per-site coverage and saves to text file
samtools depth 1339-nodup.bam > 1339-nodup.bam

## end new section

# sort the bam file
#samtools sort 1339-nodup.bam 1339-nodup.bam.sorted

#index the sorted bam file
#samtools index 1339-nodup.sorted.bam

## SNP CALLING ##
#freebayes -f /mnt/research/ged/jessica/elk/working-scripts/final.contigs.fa --ploidy 2 --min-coverage 10 --no-mnps --no-complex --min-alternate-count 2 1339-nodup.sorted.bam | vcffilter -f "QUAL > 20" > 1339-nodup-min2.vcf


cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}