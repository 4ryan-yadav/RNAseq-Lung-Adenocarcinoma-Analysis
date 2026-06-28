#!/bin/bash
set -e
cd data/sra
while read srr; do
    prefetch "$srr"
done < ../metadata/srr_list.txt
