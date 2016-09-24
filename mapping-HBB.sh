#!/bin/bash --login
#PBS -l walltime=4:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -l nodes=3:ppn=2
#PBS -N KEEP-MAPPED-OVIRG
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

# This is for mapping the elk reads to the Ovirg masked HBB globin gene, then pulling those raw reads out to fasta

# index reference genome
bwa index ovirg_masked_hbb.fna

# map raw reads to reference genome
bwa mem ovirg_masked_hbb.fna ../work/all-interleaved-elk-reads.pe.qc.fq.gz > telk_to_ovirg.sam

# index reference genome with samtools
samtools faidx ovirg_masked_hbb.fna

# convert sam to bam
samtools import ovirg_masked_hbb.fna.fai telk_to_ovirg.sam telk_to_ovirg.bam

# sort the bam file
samtools sort telk_to_ovirg.bam telk_to_ovirg.sorted

# index the sorted bam file
samtools index telk_to_ovirg.sorted.bam

# remove unmapped reads, keep mapped reads
samtools view -F 0x04 -b telk_to_ovirg.bam > /mnt/home/mizzijes/mapped_reads_telk_ovirg.bam

# convert sam file to fastq
java -jar $PICARD/SamToFastq.jar I=mapped_reads_telk_ovirg.bam FASTQ=mapped_reads_telk.fastq

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
