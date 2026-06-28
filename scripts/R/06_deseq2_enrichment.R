library(Biostrings)
library(DESeq2)
library(EnhancedVolcano)
library(org.Hs.eg.db)
library(AnnotationDbi)
library(pheatmap)
library(SummarizedExperiment)
library(clusterProfiler)
library(enrichplot)
library(pathview)



# ----------------------------
# Read featureCounts output
# ----------------------------

counts <- read.delim(
  "results/counts/gene_counts.txt",
  comment.char = "#",
  stringsAsFactors = FALSE
)

# Keep only count columns
countData <- counts[, 7:ncol(counts)]
rownames(countData) <- counts$Geneid

# ----------------------------
# Read sample metadata
# ----------------------------

colData <- read.csv("data/metadata/metadata.csv")

# Match sample names
colnames(countData) <- colData$sample_id
rownames(colData) <- colData$sample_id

cat("countData dimensions:\n")
print(dim(countData))

cat("\nFirst 10 genes:\n")
print(head(rownames(countData), 10))

cat("\nLast 10 genes:\n")
print(tail(rownames(countData), 10))

cat("\nMetadata dimensions:\n")
print(dim(colData))
# ----------------------------
# Create DESeq2 dataset
# ----------------------------

dds <- DESeqDataSetFromMatrix(
  countData = countData,
  colData = colData,
  design = ~ Condition
)

cat("\ndds dimensions:\n")
print(dim(dds))

# Filter genes with very low counts
dds <- dds[rowSums(counts(dds)) >= 10, ]

# Run DESeq2
dds <- DESeq(dds)

# Extract results
res <- results(dds)

# Convert to data frame
res_df <- as.data.frame(res)

# Significant genes
sig_genes <- subset(
  res_df,
  padj < 0.05 & abs(log2FoldChange) > 1
)

# Save results
write.csv(
  res_df,
  "results/deseq2/deseq2_results.csv",
  row.names = TRUE
)

write.csv(
  sig_genes,
  "results/deseq2/significant_genes.csv",
  row.names = TRUE
)
sig_genes <- read.csv(
  "results/deseq2/significant_genes.csv",
  row.names = 1,
  stringsAsFactors = FALSE
)

# Extract Ensembl IDs (remove version numbers)
ensembl_ids <- sub("\\..*", "", rownames(sig_genes))

# Get gene symbols
gene_symbols <- mapIds(
  org.Hs.eg.db,
  keys = ensembl_ids,
  column = "SYMBOL",
  keytype = "ENSEMBL",
  multiVals = "first"
)

# Add SYMBOL column
sig_genes$SYMBOL <- gene_symbols

# Save back to the same file
write.csv(
  sig_genes,
  "results/deseq2/significant_genes.csv",
  row.names = TRUE
)


# ----------------------------
# Volcano Plot
# ----------------------------

pdf(
  "results/figures/volcano_plot.pdf",
  width = 8,
  height = 7
)

EnhancedVolcano(
  res,
  lab = rownames(res),
  selectLab = rownames(res)[order(res$padj)][1:15],
  x = "log2FoldChange",
  y = "padj",
  pCutoff = 0.05,
  FCcutoff = 1.5,
  title = "Lung Adenocarcinoma vs Normal",
  subtitle = "Differential Expression Analysis",
  caption = "DESeq2"
)

dev.off()

# Summary
summary(res$log2FoldChange)

#PCA plot
pdf(
  "results/figures/PCA_plot.pdf",
  width = 8,
  height = 7
)
vsd <- vst(dds)
plotPCA(vsd,
        intgroup= "Condition")
dev.off()

#Heatmap
pdf(
  "results/figures/Heatmap_plot.pdf",
  width =8,
  height = 7
)
# Top 50 DEGs
top50 <- head(order(res$padj), 50)

mat <- assay(vsd)[top50, ]
mat <- mat - rowMeans(mat)

pheatmap(mat,
         annotation_col = as.data.frame(colData(vsd)[,"Condition", drop = FALSE]),
         show_rownames = TRUE,
         fontsize_row = 6)
dev.off()


#cluster profiler

sig_genes$ENSEMBL <- sub("\\..*", "", rownames(sig_genes))

gene_df <- bitr(
  sig_genes$ENSEMBL,
  fromType = "ENSEMBL",
  toType = c("ENTREZID", "SYMBOL"),
  OrgDb = org.Hs.eg.db
)
gene_df
#GO ENRICH

ego <- enrichGO(
  gene = gene_df$ENTREZID,
  OrgDb = org.Hs.eg.db,
  keyType = "ENTREZID",
  ont = "BP",
  pAdjustMethod = "BH",
  pvalueCutoff = 0.05,
  qvalueCutoff = 0.05
)
pdf(
  "results/figures/GO_dotplot.pdf",
  width =8,
  height = 7
)
dotplot(ego)
dev.off()

#KEGG
ekegg <- enrichKEGG(
  gene = gene_df$ENTREZID,
  organism = "hsa"
)
pdf(
  "results/figures/KEGG_dotplot.pdf",
  width =8,
  height = 7
)
dotplot(ekegg)
dev.off()

pdf(
  "results/figures/bar_go.pdf",
  width =8,
  height = 7
)
barplot(ego, showCategory = 15)
dev.off()

pdf(
  "results/figures/enrichment_map_go.pdf",
  width =8,
  height = 7
)
ego2 <- pairwise_termsim(ego)
emapplot(
  ego2,
  showCategory= 12,
  layout = "kk"
)
dev.off()

pdf(
  "results/figures/Heatplot_go.pdf",
  width =15,
  height = 7
)
heatplot(
  ego,
  showCategory = 5
)
dev.off()

pdf(
  "results/figures/upset_plot_go.pdf",
  width =8,
  height = 7
)
upsetplot(ego)
dev.off()

pdf(
  "results/figures/barplot_kegg.pdf",
  width =8,
  height = 7
)
barplot(ekegg)
dev.off()


pdf(
  "results/figures/KEGG_enrichment_map.pdf",
  width =8,
  height = 7
)
ekegg2 <- pairwise_termsim(ekegg)
emapplot(
  ekegg2,
  showCategory =12,
  layout= "kk"
)
dev.off()
