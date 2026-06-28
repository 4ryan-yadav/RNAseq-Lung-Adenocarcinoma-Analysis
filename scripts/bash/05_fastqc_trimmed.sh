#!/bin/bash
set -e
mkdir -p results/fastqc_trimmed results/multiqc_trimmed
fastqc data/trimmed_fastq/*.trimmed.fastq.gz -o results/fastqc_trimmed
multiqc results/fastqc_trimmed -o results/multiqc_trimmed
