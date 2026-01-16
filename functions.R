return_regex_filepath <- function(dir, prefix, reg_pattern) {
  #Return the pattern of sample dirs (eg. B006) for different files.
  regex_pattern <- "/*_matrix\\.mtx\\.gz$"
  
  # List the files
  matched_files <- list.files(
    path = str_c(dir, prefix), 
    pattern = reg_pattern, 
    full.names = TRUE
  )
  
  return(matched_files)
}

rna_atac_integration_signac <- function(proj_prefix) {
  ############################################
  ## RNA + ATAC integration with Signac
  ############################################
  
  ############################################
  ## Paths and project info
  ############################################
  message(str_c("Starting ",proj_prefix))

  intestine_path <- "/home/projects/exam_2026_22102/group2/intestine_data/"
  
  #Regex patterns
  matrix_pattern <- ".*_matrix\\.mtx\\.gz$"
  features_pattern <- ".*_features\\.tsv\\.gz$"
  barcodes_pattern <- ".*_barcodes\\.tsv\\.gz$"
  fragments_pattern <- ".*_atac_fragments\\.tsv\\.gz$"
  #peaks_pattern <- "stromal_peaks\\.bed\\.gz$"
  
  rna_matrix   <- return_regex_filepath(intestine_path, proj_prefix, matrix_pattern)
  rna_features <- return_regex_filepath(intestine_path, proj_prefix, features_pattern)
  rna_barcodes <- return_regex_filepath(intestine_path, proj_prefix, barcodes_pattern)
  fragments_file <- return_regex_filepath(intestine_path, proj_prefix, fragments_pattern)
  
  peaks_file <- str_c(intestine_path, "stromal_peaks.bed.gz") #only in one place
  
  # Check if files are recognizes
  #message("rna_matrix", rna_matrix)
  #message("rna_features", rna_features)
  #message("rna_barcodes", rna_barcodes)
  message("fragments_file", fragments_file)
  #message("peaks_file", peaks_file)
  
  ############################################
  ## 1. Load RNA counts and create Seurat object
  ############################################
  message("Loading RNA counts and creating Seurat object")
  counts <- ReadMtx(
    mtx = rna_matrix,
    features = rna_features,
    cells = rna_barcodes
  )
  
  seurat_obj <- CreateSeuratObject(
    counts = counts,
    project = proj_prefix
  )
  
  ############################################
  ## 2. Load ATAC peaks (space-separated file)
  ############################################
  message("Loading ATAC peaks")
  peaks_df <- read.table(
    peaks_file,
    header = FALSE,
    sep = "",
    stringsAsFactors = FALSE
  )
  
  peaks_df <- peaks_df[, 1:3]
  colnames(peaks_df) <- c("chr", "start", "end")
  
  peaks <- makeGRangesFromDataFrame(
    peaks_df,
    seqnames.field = "chr",
    start.field = "start",
    end.field = "end",
    keep.extra.columns = FALSE
  )
  
  peaks <- keepStandardChromosomes(peaks, pruning.mode = "coarse")
  peaks <- peaks[width(peaks) > 20]
  
  ############################################
  ## 3. Create Fragment object
  ############################################
  message("Creating Fragment object")
  fragments <- CreateFragmentObject(
    path = fragments_file,
    cells = colnames(seurat_obj)
  )
  
  ############################################
  ## 4. Create ATAC count matrix
  ############################################
  message("Creating ATAC count matrix")
  atac_counts <- FeatureMatrix(
    fragments = fragments,
    features = peaks,
    cells = colnames(seurat_obj)
  )
  
  ############################################
  ## 5. Create ChromatinAssay
  ############################################
  message("Creating ChromatinAssay")
  chrom_assay <- CreateChromatinAssay(
    counts = atac_counts,
    fragments = fragments,
    genome = "hg38"  # change to mm10 if mouse
  )
  
  ############################################
  ## 6. Add ATAC assay to Seurat object
  ############################################
  message("Adding ATAC assay to Seurat object")
  seurat_obj[["ATAC"]] <- chrom_assay
  DefaultAssay(seurat_obj) <- "RNA"
  
  message(str_c("Completed ",proj_prefix))
  return(seurat_obj)
}

filter_hemoglobin_genes <- function(gene_names) {
  # Known human hemoglobin / globin genes
  hemoglobin_genes <- c(
    "HBA1", "HBA2",
    "HBB", "HBD",
    "HBG1", "HBG2",
    "HBE1", "HBZ",
    "HBM", "HBQ1"
  )
  
  intersect(gene_names, hemoglobin_genes)
}