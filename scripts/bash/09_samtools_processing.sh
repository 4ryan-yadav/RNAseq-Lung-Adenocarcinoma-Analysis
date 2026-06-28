#!/bin/bash
set -e
mkdir -p results/bam results/sorted_bam results/bam_index
for srr in SRR31443327 SRR31443328 SRR31443329 SRR31443332 SRR31443333 SRR31443334
do
samtools view -b results/alignment/${srr}.sam > results/bam/${srr}.bam
samtools sort -@ 4 results/bam/${srr}.bam -o results/sorted_bam/${srr}.sorted.bam
samtools index results/sorted_bam/${srr}.sorted.bam
samtools flagstat results/sorted_bam/${srr}.sorted.bam > results/bam_index/${srr}.flagstat.txt
done
