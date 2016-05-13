#!/bin/bash --login
#PBS -l walltime=40:00:00
#PBS -l mem=100gb
#PBS -l nodes=1:ppn=8
#PBS -m abe
#PBS -N elk-sub
#PBS -A ged

cd ${PBS_O_WORKDIR}

## TRIMMING - FROM RAW READS ##

# FastQC
source hpcc.modules

mkdir -p output-fq
for filename in *.fastq.gz;
do
    fastqc -o output-fq $filename
done

rm -f orphans.fastq.gz
rm -f TruSeq3-PE.fa

# Get Illumina TruSeq3 Adapters
wget https://anonscm.debian.org/cgit/debian-med/trimmomatic.git/plain/adapters/TruSeq3-PE.fa

for filename in *_R1_*.fastq.gz
do
     base=$(basename $filename .fastq.gz)
     echo $base
     baseR2=${base/_R1_/_R2_}
     echo $baseR2

     java -jar $TRIM/trimmomatic PE -phred33 ${base}.fastq.gz ${baseR2}.fastq.gz \
     intermediate/${base}.trim.qc.fq.gz intermediate/s1_se \
     intermediate/${baseR2}.trim.qc.fq.gz intermediate/s2_se \
     ILLUMINACLIP:TruSeq3-PE.fa:2:40:15 \
     LEADING:2 TRAILING:2 \
     SLIDINGWINDOW:4:2 \
     MINLEN:25

     # save the orphans
     gzip -9c intermediate/s{1,2}_se >> intermediate/orphans.fq.gz
     rm -f intermediate/s{1,2}_se

done

# FastQC again

for filename in intermediate/*.trim.qc.fq.gz;
do
    fastqc -o output-fq $filename
done

## INTERLEAVE READS - FROM TRIMMED READS ##

set -o pipefail
set -x
module use /opt/software/ged-software/modulefiles/
module load anaconda
source activate elk
module swap GNU GNU/4.9

set -e

for filename in intermediate/*_R1_*.trim.qc.fq.gz
do
     # first, make the base by removing .extract.fastq.gz
     base=$(basename $filename .trim.qc.fq.gz)
     echo $base

     # now, construct the R2 filename by replacing R1 with R2
     baseR2=${base/_R1_/_R2_}
     echo $baseR2

     # construct the output filename
     output=${base/_R1_/}.pe.trim.qc.fq.gz

     (interleave-reads.py intermediate/${base}.trim.qc.fq.gz intermediate/${baseR2}.trim.qc.fq.gz | \
         gzip > intermediate/$output)

done

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
