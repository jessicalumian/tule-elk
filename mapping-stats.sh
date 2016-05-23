#!/bin/bash --login
#PBS -l walltime=8:00:00
#PBS -l mem=200gb
#PBS -m abe
#PBS -N elk-mapping-stats
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

# If you want to view the alignment
# fix input file samtools tview all-interleaved-elk-reads.sorted.bam final.contigs.fa

touch ${PBS_O_WORKDIR}/mapping-stats.txt

echo Number of reads that did not align: >> ${PBS_O_WORKDIR}/mapping-stats.txt
# How many reads did not align
samtools view -c -f 4 all-interleaved-elk-reads.sorted.bam >> ${PBS_O_WORKDIR}/mapping-stats.txt

echo Number of reads that aligned: >> ${PBS_O_WORKDIR}/mapping-stats.txt
# How many reads did align
samtools view -c -F 4 all-interleaved-elk-reads.sorted.bam >> ${PBS_O_WORKDIR}/mapping-stats.txt

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
