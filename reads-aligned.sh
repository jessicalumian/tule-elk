#!/bin/bash --login
#PBS -l walltime=78:00:00
#PBS -l mem=500gb
#PBS -l nodes=1:ppn=8
#PBS -m abe
#PBS -N elk-mapping-stats
#PBS -A ged

cd ${PBS_O_WORKDIR}

source hpcc.modules

touch ${PBS_O_WORKDIR}/mapping-stats.txt

for i in /mnt/home/mizzijes/*sorted.bam

  # how many reads aligned in each sample
  echo ${i} >> ${PBS_O_WORKDIR}/2016-12-13-mapping-stats.txt
  echo Number of reads that did not align: >> ${PBS_O_WORKDIR}/2016-12-13-mapping-stats.txt
  samtools view -c -f 4 ${i} >> ${PBS_O_WORKDIR}/mapping-stats.txt

  # how many reads did not align in each sample
  echo Number of reads that aligned: >> ${PBS_O_WORKDIR}/2016-12-13-mapping-stats.txt
  samtools view -c -F 4 ${i} >> ${PBS_O_WORKDIR}/2016-12-13-mapping-stats.txt

done

cat ${PBS_NODEFILE}
env | grep PBS
qstat -f ${PBS_JOBID}
