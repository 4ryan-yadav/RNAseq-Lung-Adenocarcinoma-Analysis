#!/bin/bash
set -e
mkdir -p data/trimmed_fastq results/fastp
for srr in SRR31443327 SRR31443328 SRR31443329 SRR31443332 SRR31443333 SRR31443334
do
fastp -i data/raw_fastq/${srr}_1.fastq.gz -I data/raw_fastq/${srr}_2.fastq.gz -o data/trimmed_fastq/${srr}_1.trimmed.fastq.gz -O data/trimmed_fastq/${srr}_2.trimmed.fastq.gz -h results/fastp/${srr}_fastp.html -j results/fastp/${srr}_fastp.json
done
