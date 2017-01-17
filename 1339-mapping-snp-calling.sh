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

# sort the bam file
#samtools sort 1339-elk-reads.bam 1339-elk-reads.sorted

## NEW SECTION - REMOVING CLONES ##

# mark duplicates based on start and end position of reads
#java -jar $PICARD/MarkDuplicates.jar I=1339-elk-reads.sorted.bam O=1339_nodup.bam M=Metrics

# remove duplicates from paired end reads ( -S flag for unpaired)
#samtools rmdup 1339_nodup.bam 1339-nodup.bam

# prints per-site coverage and saves to text file
#samtools depth 1339-nodup.bam > 1339-nodup.depth.txt

#index the sorted bam file
#samtools index 1339-nodup.bam

## other commands
# possibly necessary ##subset bam file based on coverage of 10 or more
#samtools depth 1339-nodup.bam | awk '($3>9) {print}' | wc -l > 1339-nodup-cov10.bam

## end new section

## SNP CALLING ##

freebayes -f /mnt/research/ged/jessica/elk/working-scripts/final.contigs.fa --ploidy 2 --min-coverage 10 --no-mnps --no-complex --min-alternate-count 2 1339-nodup.bam | vcffilter -f "QUAL > 20" > 1339-nodup-min2.vcf

## FINDING HETEROZYGOUS SITES ##

# find 0/1 het calls in new vcf and print to file
echo 1339-nodup-min2.vcf >> 1339-het-counts.txt
grep -c "0/1" 1339-nodup-min2.vcf >> 1339-het-counts.txt

# find all sites above coverage threshold (set to 10 in snp command) and print to file

# count all sites 10+ and put in intermediate file
awk '$3 > 9' 1339-nodup.depth.txt >> 1339-thresh-intermediate-het-counts.txt

# count lines, each corresponding to site over cov 10 and print in stat file
echo het-sites-above-10 >> 1339-het-counts.txt
wc -l 1339-thresh-intermediate-het-counts.txt >> 1339-het-counts.txt

# divide 0/1 het calls by all 10+ cov sites from vcf for heterozygosity

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
