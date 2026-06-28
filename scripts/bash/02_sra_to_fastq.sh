#!/bin/bash
set -e
mkdir -p data/raw_fastq
cd data/raw_fastq
while read srr; do
    fasterq-dump --split-files ../sra/$srr
done < ../metadata/srr_list.txt
gzip *.fastq
