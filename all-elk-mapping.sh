#!/bin/bash --login
#PBS -l walltime=120:00:00
#PBS -l mem=600gb
#PBS -m abe
#PBS -N all-elk-mapping-to-het-counts
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

### ELK 1339 ###

for i in /mnt/research/ged/jessica/elk/interleaved-reads/*fastq.gz
do

  base=$(basename $i .fastq.gz)

  ## MAPPING ##

  # map raw reads from elk to reference genome
  bwa mem /mnt/research/ged/jessica/elk/working-scripts/final.contigs.fa $i > ${base}-elk-reads.sam

  # convert sam to bam
  samtools import /mnt/research/ged/jessica/elk/working-scripts/contigs.fa.fai ${base}-elk-reads.sam ${base}-elk-reads.bam

  # sort the bam file
  samtools sort ${base}-elk-reads.bam ${base}-elk-reads.sorted

  # mark duplicates based on start and end position of reads
  java -jar $PICARD/MarkDuplicates.jar I=${base}-elk-reads.sorted.bam O=${base}_nodup.bam M=$base}-metrics

  # remove duplicates from paired end reads ( -S flag for unpaired)
  samtools rmdup ${base}_nodup.bam ${base}-nodup.bam

  # prints per-site coverage and saves to text file
  samtools depth ${base}-nodup.bam > ${base}-nodup.depth.txt
  
  #index the sorted bam file
  samtools index ${base}-nodup.bam

  ## SNP CALLING ##

  freebayes -f /mnt/research/ged/jessica/elk/working-scripts/final.contigs.fa --ploidy 2 --min-coverage 10 --no-mnps --no-complex --min-alternate-count 2 ${base}-nodup.bam | vcffilter -f "QUAL > 20 & DP > 9" > ${base}-nodup-min2-cov10.vcf

  # find 0/1 het calls in new vcf and print to file
  echo ${base}-nodup-min2-cov10.vcf >> ${base}-het-counts.txt
  grep -c "0/1" ${base}-nodup-min2-cov10.vcf >> ${base}-het-counts.txt

  # count all sites 10+ and put in intermediate file
  awk '$3 > 9' ${base}-nodup.depth.txt >> ${base}-thresh-intermediate-het-counts.txt

  # count lines, each corresponding to site over cov 10 and print in stat file
  echo het-sites-above-10 >> ${base}-het-counts.txt
  wc -l ${base}-thresh-intermediate-het-counts.txt >> ${base}-het-counts.txt

  # divide 0/1 het calls by all 10+ cov sites from vcf for heterozygosity

done

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
