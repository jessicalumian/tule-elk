#!/bin/bash
# clunky code to extract reads from whole fasta file 
# the extracted reads will be the matches from a query sequence (for example,
# a gene), using the elk genome as a database

# download ncbi blast command line
# use elk genome as database, use gene in question as query

# Step one: use output file to get list of contig IDs

# remove header of file (make sure file name has identifying info about query)
# cp file to keep original output file safe and use working-file.txt as temp name

cp "$1" working-file.txt

# get rid of header information
tail -n +20 working-file.txt > working-file-headless.txt

# take anything starting with "k" (all read IDs) into new file

while read working-file-headless.txt; do


# note - I am giving up on this because this is something I only need to do twice, and not automate. Also if I need to write this again I'll put it in pythong
