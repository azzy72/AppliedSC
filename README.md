# RNA–ATAC Integration Pipeline (Signac)

This repository contains a reproducible pipeline for importing, organizing, and integrating paired RNA-seq and ATAC-seq single-cell data using Seurat and Signac. The workflow is designed around Human Cell Atlas (HCA) datasets and emphasizes clear data organization, sample-level processing, and computational efficiency.

⚠️ Note: This repository is under active development. The schematic and structure may evolve as preprocessing and downstream analysis steps are finalized.

⸻

## 🧭 Project Overview

The pipeline is divided into two conceptual stages:
	1.	Data Import & Organization
	2.	Preprocessing & Integration

The guiding principle is to process and quality-control samples individually before merging, minimizing memory usage and computational overhead during integration.

⸻

## 📁 Data Import

### 1. Source Dataset (HCA)

Data are sourced from the Human Cell Atlas (HCA) portal:
	•	Project: HuBMAP: HBM692.JRZB.356

Metadata from HCA is used to:
	•	Understand sample groupings
	•	Identify which files belong to which biological samples
	•	Map raw files to sample-specific directories

⸻

### 2. Downloading Data

All raw data are downloaded via the HCA UI and stored locally.

⸻

### 3. File Organization (UNIX)

A UNIX-based helper script is used to organize files:
	•	sort_pull.sh

This script:
	•	Parses downloaded HCA files
	•	Sorts them into sample-specific directories

Example directory naming convention:

B006-A-002/
├── matrix.mtx.gz
├── features.tsv.gz
├── barcodes.tsv.gz
├── atac_fragments.tsv.gz

Each directory corresponds to a single biological sample.

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

## 📂 Repository Structure (Planned)

├── scripts/
│   ├── sort_pull.sh
│   ├── rna_atac_integration_signac.R
│   └── helpers/
├── data/
│   ├── raw/
│   └── processed/
├── figures/
├── README.md
└── environment/


⸻

## 📦 Dependencies

Key R packages:
	•	Seurat
	•	Signac
	•	stringr
	•	tidyverse

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

Contributions, suggestions, and issue reports are welcome. Please open an issue or submit a pull request.

⸻

## 📜 License

This project is released under the MIT License (or specify otherwise).

⸻

## 📬 Contact

For questions or collaboration, please reach out via GitHub issues or discussions.
