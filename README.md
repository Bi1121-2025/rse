# Research Software Engineering (RSE) - Protein Interaction Network Analysis

This repository contains code and examples for the **Bi1121c - Introduction to Research Software Engineering** course. The main focus is on analyzing protein interaction networks using R, with an emphasis on reproducible, readable, and testable research software.

## Features

- **Protein Data Analysis:** Load, clean, and explore protein datasets (e.g., from the `tidybiology` package).
- **Network Construction:** Build protein interaction networks using UniProt data.
- **Subcellular Localization:** Annotate proteins with subcellular locations and visualize co-localization.
- **Visualization:** Generate publication-quality network plots and boxplots using `ggplot2` and `ggraph`.
- **Command-Line Tools:** Run analyses from the command line with flexible arguments (see `04b_cli.R`).
- **Best Practices:** Examples of good coding style, explicit data handling, and unit testing in R.
- **Unit Testing:** Demonstrations of how to write and use tests for R functions.

## Getting Started

### Prerequisites

- R (>= 4.0)
- R packages: `tidybiology`, `dplyr`, `tidyr`, `plyr`, `igraph`, `ggraph`, `ggplot2`, `UniprotR`, `argparse`, `testthat`

You will need several R packages for this project. Most can be installed from CRAN, but some (such as Biostrings and GenomicAlignments) must be installed from Bioconductor.

```r
# Install CRAN packages
install.packages(c(
  "devtools", "tidybiology", "dplyr", "tidyr", "plyr", "igraph",
  "ggraph", "ggplot2", "UniprotR", "argparse", "testthat"
))

# Install Bioconductor packages
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(c("Biostrings", "GenomicAlignments"))
```

### Example Usage

#### 1. Generate a CSV of UniProt IDs

```r
# See code_examples.R for details
library(tidybiology)
data(proteins, package = "tidybiology")
write.csv(
  data.frame(uniprot_id = sample(unique(proteins$uniprot_id), 20)),
  "uniprot_ids.csv", row.names = FALSE
)
```

#### 2. Run the Command-Line Analysis

```sh
Rscript 04b_cli.R uniprot_ids.csv output_plot.png --locations Nucleus Cytoplasm
```

#### 3. Explore Code Examples

- See `code_examples.R` for best practices in R: variable naming, function design, explicit data handling, and unit testing.

## Project Structure

- `03_refactored.R` – Modular, well-documented R script for protein network analysis.
- `04b_cli.R` – Command-line interface for flexible, reproducible analysis.
- `code_examples.R` – Illustrative code snippets for R best practices and testing.
- `uniprot_ids.csv` – Example input file with UniProt IDs.
- `README.md` – This file.

## Contributing

Contributions and suggestions are welcome! Please open an issue or submit a pull request.

## License

This project is for educational purposes. See course materials for details.

---

*Created for the Bi1121c - Introduction to Research Software Engineering course.*