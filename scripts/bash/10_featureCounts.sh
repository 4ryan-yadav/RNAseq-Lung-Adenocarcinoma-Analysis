#!/bin/bash
set -e
mkdir -p results/counts
featureCounts -T 4 -p --countReadPairs -a data/reference/gencode.v49.annotation.gtf -o results/counts/gene_counts.txt results/sorted_bam/SRR31443327.sorted.bam results/sorted_bam/SRR31443328.sorted.bam results/sorted_bam/SRR31443329.sorted.bam results/sorted_bam/SRR31443332.sorted.bam results/sorted_bam/SRR31443333.sorted.bam results/sorted_bam/SRR31443334.sorted.bam
