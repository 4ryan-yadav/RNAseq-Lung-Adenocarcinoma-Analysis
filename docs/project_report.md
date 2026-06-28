# End-to-End RNA-seq Analysis of Lung Adenocarcinoma

## Objective

This project performs an end-to-end RNA-seq analysis to identify differentially expressed genes and dysregulated biological pathways between normal lung tissue and lung adenocarcinoma samples.

## Dataset

- GEO Accession: GSE282617
- Organism: Homo sapiens
- Genome: GRCh38
- Annotation: GENCODE v49
- Samples:
  - 3 Normal
  - 3 Tumor
- Sequencing: Paired-end RNA-seq

## Workflow

1. Download RNA-seq data from GEO (GSE282617)
2. Convert SRA files to FASTQ
3. Perform quality assessment using FastQC and MultiQC
4. Trim low-quality reads and adapters using fastp
5. Align reads to the GRCh38 reference genome using HISAT2
6. Convert, sort, and index BAM files using Samtools
7. Quantify gene expression using featureCounts
8. Perform differential expression analysis using DESeq2
9. Conduct GO and KEGG enrichment analyses
10. Visualize results using PCA, Volcano plot, Heatmap, GO, and KEGG plots

## Results

### Differential Expression

Differential expression analysis was performed using DESeq2 to identify genes significantly altered between lung adenocarcinoma and normal lung tissue.

### Functional Enrichment

GO enrichment identified biological processes including:

- Extracellular matrix organization
- Extracellular structure organization
- Cell-substrate adhesion
- Mesenchymal development
- Mesenchymal differentiation
- Regulation of small GTPase-mediated signaling

KEGG pathway analysis identified:

- ECM–receptor interaction
- Focal adhesion
- Mucin-type O-glycan biosynthesis

## Conclusion

This RNA-seq analysis identified genes and pathways associated with lung adenocarcinoma progression. Enrichment analysis highlighted extracellular matrix remodeling, cell adhesion, and signaling pathways consistent with tumor invasion and metastasis. The complete workflow is reproducible and suitable for downstream biological interpretation.
