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

SNP calling and determining heterozygous sites:

1. Using assembly file, mapping using bwa and Samtools and call polymorphic sites using freebayes - Example for one elk: [1339-mapping-snp-calling.sh](https://github.com/jessicamizzi/tule-elk/blob/master/1339-mapping-snp-calling.sh)
2. **Optional** - generate mapping stats - [mapping-stats.sh](https://github.com/jessicamizzi/tule-elk/blob/master/mapping-stats.sh)
3. Count heterozygous sites in each elk - [find-het-sites.sh](https://github.com/jessicamizzi/tule-elk/blob/master/find-het-sites.sh)
4. Find sequenced sites with coverage greater than threshold from the vcf files from each elk - [total-vcf-sites.sh](https://github.com/jessicamizzi/tule-elk/blob/master/total-vcf-sites.sh)

Because this was my first time mapping, I made a diagram for my own reference that might be helpful to others in a similar position:

![alt text](https://github.com/jessicamizzi/tule-elk/blob/master/images/mapping-diagram.png)


## Hey, why study Tule Elk anyway?
I'm glad you asked! Here are some great reasons to study Tule Elk:

![alt text](https://github.com/jessicamizzi/tule-elk/blob/master/images/elk-pic-1.png)

![alt text](https://github.com/jessicamizzi/tule-elk/blob/master/images/elk-pic-2.png)

![alt text](https://github.com/jessicamizzi/tule-elk/blob/master/images/elk-pic-3.png)

### In all seriousness
The tule elk (Cervus elaphus nannodes) is a California-endemic subspecies that underwent a major genetic bottleneck when its numbers were reduced to as few as 3 individuals in the 1870s (McCullough 1969; Meredith et al. 2007). Since then, the population has grown to an estimated 4,300 individuals which currently occur in 22 distinct herds (Hobbs 2014). Despite their higher numbers today, the historical loss of genetic diversity combined with the increasing fragmentation of remaining habitat pose a significant threat to the health and management of contemporary populations. As populations become increasingly fragmented by highways, reservoirs, and other forms of human development, risks intensify for genetic impacts associated with inbreeding. By some estimates, up to 44% of remaining genetic variation could be lost in small isolated herds in just a few generations (Williams et al. 2004). For this reason, the Draft Elk Conservation and Management Plan and California Wildlife Action Plan prioritize research aimed at facilitating habitat connectivity, as well as stemming genetic diversity loss and habitat fragmentation (Hobbs 2014; CDFW 2015).

You can read more about this [on Titus' blog](http://ivory.idyll.org/blog/2016-tule-elk-draft.html) until we get the paper written.
