#!/bin/bash --login
#PBS -l walltime=60:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -N elk-mapping
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

# gunzip *.pe.qc.fq.gz

# index reference genome
bwa index final.contigs.fa

# map raw reads to reference genome
bwa mem final.contigs.fa ../work/all-interleaved-elk-reads.pe.qc.fq.gz > all-interleaved-elk-reads.sam

# index reference genome with samtools
samtools faidx final.contigs.fa

# convert sam to bam
samtools import contigs.fa.fai all-interleaved-elk-reads.sam all-interleaved-elk-reads.bam

# sort the bam file
samtools sort all-interleaved-elk-reads.bam all-interleaved-elk-reads.sorted

# index the sorted bam file
samtools index all-interleaved-elk-reads.sorted.bam

# If you want to view the alignment
# fix input file samtools tview S14-2919_S80_L007.sorted.bam contigs.fa

# How many reads did not align
# fix input file samtools view -c -f 4 S14-2919_S80_L007.bam

# How many reads did align
# fix input file samtools view -c -F 4 S14-2919_S80_L007.bam

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
