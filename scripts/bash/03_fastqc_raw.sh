#!/bin/bash
set -e
mkdir -p results/fastqc_raw results/multiqc_raw
fastqc data/raw_fastq/*.fastq.gz -o results/fastqc_raw
multiqc results/fastqc_raw -o results/multiqc_raw
