# RNA–ATAC Integration Pipeline (Signac)

This repository contains a reproducible pipeline for importing, organizing, and integrating paired RNA-seq and ATAC-seq single-cell data using Seurat and Signac. The workflow is designed around Human Cell Atlas (HCA) datasets and emphasizes clear data organization, sample-level processing, and downstream analysis.

⚠️ Note: This repository is under active development. The schematic and structure may evolve as preprocessing and downstream analysis steps are finalized.

⸻

## 🧭 Project Overview

The pipeline is divided into the following conceptual stages, which aligns with the naming convention of the quatro documents:

	1.	Data Import & Organization
	2.	Data Preprocessing 
	3.	Data Integration
	4.	Cell type annotation & Assignment of clusters
	5a.	Differential gene expression & Gene enrichment
	5b. Differential composition analysis
	5c. Trajectory analysis
	5d. Gene regulation interaction
	5e. Cell-cell communication

The guiding principle is to process and quality-control samples individually before merging, minimizing memory usage and computational overhead during integration.

⸻

## 📁 Data Import

### 1. Source Dataset (HCA)

Data are sourced from the Human Cell Atlas (HCA), under the name [Organization of the human intestine at single-cell resolution]([url](https://explore.data.humancellatlas.org/projects/16241d82-3119-4bdd-bba5-5097c0591ba0))

The collection metadata from HCA is used to:
	•	Understand sample groupings
	•	Identify which files belong to which biological samples
	•	Map raw files to sample-specific directories
Proving crucial in the harvesting and organization of the data.

⸻

### 2. Downloading Data

All raw data are downloaded via the HCA UI and stored locally.

⸻

### 3. File Organization (UNIX)

Through basic UNIX commands, the data is reorganized into sample directories, containing raw matrix files used in the construction of a sample-specific seurat object

Example directory naming convention:

	B006-A-002/
	├── matrix.mtx.gz
	├── features.tsv.gz
	├── barcodes.tsv.gz
	├── atac_fragments.tsv.gz
	├── atac_fragments.tsv.gz.tbi

Where matrix denotes the scRNA count matrix, features and barcodes (cells) provide metadata for the scRNA transcriptomics data. Alternatively, atac_fragment.tsv.gz contains the scATAC-seq intervals, where the corresponding .tbi file denotes the indexing of the intervals.

Hence, each directory corresponds to a single biological sample.

⸻

## 🔧 Processing & Integration (R / RStudio)

All downstream steps are performed in R, primarily using Seurat and Signac.

Core Function

The main entry point for processing a sample is:

rna_atac_integration_signac()

This function:

	•	Reads RNA and ATAC inputs from a sample directory
	•	Constructs Seurat objects
	•	Performs modality-specific preprocessing

⸻

## 🧪 Sample-Level Workflow

For each sample:

	1.	Create Seurat objects
	•	RNA assay
	•	ATAC assay
	2.	Write sample-specific Seurat objects to disk
	•	Enables checkpointing
	•	Avoids recomputation
	3.	Quality Control (QC)
	•	Performed before merging
	•	Filtered objects are saved back to disk

⸻

## 🔗 Merging Strategy

After QC:

	•	Individual, filtered Seurat objects are merged into a single object
	•	The merged object is saved to disk for downstream analysis

Rationale

Performing QC before merging significantly reduces computational load and memory usage during integration, especially for large multi-sample datasets.


⸻

## 📦 Dependencies

Key R packages:

	•	Seurat
	•	Signac
	•	stringr
	•	tidyverse
	•	GenomicRanges

System requirements:

	•	UNIX-compatible OS
	•	R (≥ 4.2 recommended)
	•	RStudio (optional but recommended)

⸻

## 🚧 Current Status
	•	✅ Data import and organization
	•	✅ Sample-level Seurat object creation
	•	🔄 QC parameter tuning (in progress)
	•	⏳ Downstream integration and visualization (planned)

⸻

## 🤝 Contributing

Contributions, suggestions, and issue reports are limited to denoted group members, as the project is intended for a DTU course (22102) hand-in.

The collaborators are:

	•	s203566
	•	s204643
	•	s215092
	•	s215045

⸻

## 📬 Contact

For questions or collaboration, please reach out via GitHub issues or discussions.
