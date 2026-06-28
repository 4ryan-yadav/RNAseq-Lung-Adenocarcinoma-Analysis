#!/bin/bash
set -e
mkdir -p data/reference/hisat2_index
hisat2-build -p 4 data/reference/GRCh38.primary_assembly.genome.fa data/reference/hisat2_index/grch38
