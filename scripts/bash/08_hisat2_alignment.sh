#!/bin/bash
set -e
mkdir -p results/alignment
for srr in SRR31443327 SRR31443328 SRR31443329 SRR31443332 SRR31443333 SRR31443334
do
hisat2 -p 4 -x data/reference/hisat2_index/grch38 -1 data/trimmed_fastq/${srr}_1.trimmed.fastq.gz -2 data/trimmed_fastq/${srr}_2.trimmed.fastq.gz -S results/alignment/${srr}.sam
done
