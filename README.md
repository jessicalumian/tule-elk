# Tule Elk de novo genome assembly and SNP calling

This repo contains scripts used for de novo tule elk genome assembly and SNP calling as described in [Titus' blog post](http://ivory.idyll.org/blog/2016-tule-elk-draft.html).

Software versions (also listed in [hpcc.modules](https://github.com/jessicamizzi/tule-elk/blob/master/hpcc.modules) file):

* FastQC v0.11.3
* Trimmomatic v0.30
* khmer v2.0
* bwa v0.7.7.r441
* SAMTools v1.2
* MEGAHIT v1.0.5 (installed by cloning the [github repo](https://github.com/voutcn/megahit))

Assembly steps:

1. Quality Evaluation using FastQC (no script for this, just `fastqc *.fq.gz` in the same directory as the files)
2. Trimming using trimmomatic - [interleave-to-before-asm.sh](https://github.com/jessicamizzi/tule-elk/blob/master/interleave-to-before-asm.sh) (great script name, I know)
3. Interleaving reads using khmer - [interleave-to-before-asm.sh](https://github.com/jessicamizzi/tule-elk/blob/master/interleave-to-before-asm.sh)
4. Assembly using MEGAHIT - [megahit-asm.sh](https://github.com/jessicamizzi/tule-elk/blob/master/megahit-asm.sh) (I was initially using velvet but found it too slow, but the scripts are still up)
5. Assembly evaluation using QUAST - [quast.sh](https://github.com/jessicamizzi/tule-elk/blob/master/quast.sh) (Results are available for viewing [here](https://docs.google.com/spreadsheets/d/1nhKOLVWc_VQt31xmik9_qEKK1S5U6biXARm7qJ-OCOQ/edit?usp=sharing))

SNP calling steps:

1. Using assembly file, mapping using bwa and Samtools - [mapping.sh](https://github.com/jessicamizzi/tule-elk/blob/master/mapping.sh)
2. **Optional** - generate mapping stats - [mapping-stats.sh](https://github.com/jessicamizzi/tule-elk/blob/master/mapping-stats.sh)
3. SNP calling using freebayes - [freeb-vcf-snps-calling.sh](https://github.com/jessicamizzi/tule-elk/blob/master/freeb-vcf-snps-calling.sh) *Note* - this script is from the awesome Zach Lounsberry, on Twitter as [@indoorecology](https://twitter.com/indoorecology) and blogging at [http://www.ztlecology.info/](http://www.ztlecology.info/)

Because this was my first time mapping, I made a diagram for my own reference that might be helpful to others in a similar position:

![alt text](https://github.com/jessicamizzi/tule-elk/blob/master/images/mapping-diagram.png)
