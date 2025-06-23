# Install packages
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("TCGAbiolinks")
library(TCGAbiolinks)

library(SummarizedExperiment)
query <- GDCquery(
    project = "TCGA-BRCA",
    data.category = "Transcriptome Profiling",
    data.type = "Gene Expression Quantification",
    sample.type = c("Primary Tumor", "Solid Tissue Normal")
)

# Download only ~20 samples
# Optional: limit to 40 samples for quick work
samples <- getResults(query, cols = c("cases"))[1:40]
query$results[[1]] <- query$results[[1]][query$results[[1]]$cases %in% samples, ]

# Download data
GDCdownload(query)

# Prepare data
data <- GDCprepare(query)


count_matrix <- assay(data, "unstranded")  # You can also use "stranded_first" etc.
write.table(count_matrix, file = "TCGA_BRCA_counts.tsv", sep = "\t", quote = FALSE)

sample_metadata <- as.data.frame(colData(data))
sample_metadata_clean <- sample_metadata[ , !sapply(sample_metadata, is.list)]
write.table(sample_metadata_clean, file = "TCGA_BRCA_metadata.tsv", sep = "\t", quote = FALSE, row.names = FALSE)

gene_metadata <- as.data.frame(rowData(data))
write.table(gene_metadata, file = "TCGA_BRCA_gene_metadata.tsv", sep = "\t", quote = FALSE, row.names = TRUE)
