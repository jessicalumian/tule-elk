#!/usr/bin/python

# open file, make into list, if line starts with ACTG and is less than defined length, print the length
contig_len_file = open('contig_lengths_202.txt', 'w')
with open('telk.contigs.fa') as f:
    mylist = list(f)
    for line in mylist:
        if line.startswith( 'A' ) or line.startswith( 'T' ) or line.startswith( 'C') or line.startswith( 'G'):
            if len(line) < 202:
                contig_length = str(len(line))
                contig_len_file.write(contig_length + '\n')
contig_len_file.close()
