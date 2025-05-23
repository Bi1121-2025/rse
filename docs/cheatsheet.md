# FAIR Research Software Tools and Practices in Life Sciences

This document summarizes tools, platforms, and best practices that support the creation of FAIR (Findable, Accessible, Interoperable, Reusable) research software in the life sciences, with a particular emphasis on R and general-purpose open science platforms.

---

## ᴍ Findable

| Resource / Tool              | Type                | Purpose                                                                                      | Usage Snippet / Example                                 |
| ---------------------------- | ------------------- | -------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| **Zenodo**                   | Repository          | Assigns DOIs for software and datasets, integrates with GitHub for automated archiving.      | `zen4R::deposit_new(title = "MyTool")` or manual upload |
| **bio.tools**                | Registry            | A curated registry for bioinformatics tools, structured using the EDAM ontology.             | Register via website or API                             |
| **FAIRsharing.org**          | Registry            | Lists metadata standards, repositories, and policies supporting FAIR practices.              | Manual registration                                     |
| **Identifiers.org**          | Identifier Resolver | Provides globally unique, resolvable identifiers for life science entities.                  | URL: `https://identifiers.org/`                         |
| **codemeta / codemeta.json** | Metadata Schema     | A JSON-based schema to describe software metadata using a standard vocabulary.               | `codemeta::write_codemeta("mypackage")`                 |
| **roxygen2 (R)**             | R package           | Automatically generates metadata from code comments to populate help files and NAMESPACE.    | `roxygen2::roxygenise()`                                |
| **pkgdown (R)**              | R package           | Creates a searchable website for R packages from documentation and vignettes.                | `pkgdown::build_site()`                                 |
| **rrtools (R)**              | R package           | Provides templates for R research compendia including metadata and reproducibility elements. | `rrtools::use_compendium("myproject")`                  |

---

## ᴠ Accessible

| Resource / Tool                   | Type              | Purpose                                                                       | Usage Snippet / Example                                       |
| --------------------------------- | ----------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------- |
| **CRAN**                          | R package repo    | Primary repository for R packages, includes metadata, checks, and binaries    | `install.packages("mypackage")`                               |
| **Bioconductor**                  | R package repo    | Specialized repository for bioinformatics tools in R, with versioned releases | `BiocManager::install("DESeq2")`                              |
| **conda-forge / conda R channel** | Package manager   | Cross-platform environment manager supporting R packages                      | `conda install -c conda-forge r-dplyr`                        |
| **GitHub**                        | Code Repository   | Public access to source code, issue tracking, version control                 | `git clone https://github.com/user/repo.git`                  |
| **Zenodo / Figshare**             | Data Repositories | Host software and data; provide DOIs and long-term preservation               | Use web interface or `zen4R` API                              |
| **httr / curl / requests**        | R / CLI / Python  | Access APIs and remote files from code                                        | `httr::GET("https://...")` / `curl -O https://...`            |
| **gh (R)**                        | R package         | Interface with GitHub’s API to manage repos, issues, releases                 | `gh::gh("GET /repos/:owner/:repo")`                           |
| **Europe PMC**                    | Literature + API  | Access to publications and software via open API                              | `https://www.ebi.ac.uk/europepmc/webservices/rest/search?...` |
| **git2r (R)**                     | R package         | Native Git support from R; commit, push, pull operations                      | `git2r::push(repo)`                                           |

---

## ᴊ Interoperable

| Resource / Tool            | Type               | Purpose                                                                            | Usage Snippet / Example                           |
| -------------------------- | ------------------ | ---------------------------------------------------------------------------------- | ------------------------------------------------- |
| **OBO Foundry**            | Ontology Library   | Provides community-approved ontologies for biomedical research                     | Use IDs like `GO:0008150`, `CHEBI:15377`          |
| **EDAM Ontology**          | Ontology           | Describes bioinformatics operations, data types, and formats                       | Tag with EDAM concepts like `operation_3438`      |
| **BioSchemas**             | Markup Standard    | Adds structured metadata to web pages for biological data/software discoverability | `itemscope itemtype="https://bioschemas.org/..."` |
| **Bioconductor (R)**       | R ecosystem        | Provides interoperable data structures and standards for genomic analyses          | `library(SummarizedExperiment)`                   |
| **annotate / biomaRt (R)** | R packages         | Access standardized gene annotation databases and IDs                              | `biomaRt::getBM(...)`                             |
| **jsonlite / yaml (R)**    | R packages         | Convert data to JSON or YAML for platform-independent exchange                     | `jsonlite::toJSON(mydata)` / `yaml::as.yaml(obj)` |
| **ISA-tools**              | Metadata Framework | Captures rich metadata in life science experiments using the ISA-Tab format        | Tools available via `isa-api`                     |

---

## ᴜ Reusable

| Resource / Tool       | Type               | Purpose                                                                            | Usage Snippet / Example                                               |
| --------------------- | ------------------ | ---------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| **Software Heritage** | Archive            | Long-term preservation of source code with persistent identifiers (SWH-ID)         | Archive via web or reference via `swh:1:dir:...`                      |
| **RO-Crate**          | Packaging Standard | JSON-LD-based format for packaging research outputs with machine-readable metadata | `ro-crate-metadata.json`                                              |
| **usethis (R)**       | R package          | Automates inclusion of licenses, README, tests, and CI tools                       | `usethis::use_mit_license("Your Name")` / `usethis::use_readme_rmd()` |
| **testthat (R)**      | R package          | Provides unit testing framework for R packages                                     | `testthat::test_that("test", expect_equal(...))`                      |
| **renv (R)**          | R package          | Manages project-specific package libraries for reproducible R environments         | `renv::init(); renv::snapshot()`                                      |
| **R-universe**        | R publishing       | Automatically builds, tests, and distributes R packages with a web interface       | Set up via GitHub Actions                                             |

---

## 🛠️ Clean, Testable Software Development

| Tip / Practice                         | Tool / Resource               | Purpose / Benefit                                                                | Usage Snippet / Example                                                 |
| -------------------------------------- | ----------------------------- | -------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| **Use consistent coding style**        | `styler`, `lintr` (R)         | Automatically format and lint R code to ensure readability and style consistency | `styler::style_dir()` / `lintr::lint("script.R")`                       |
| **Structure your code into functions** | Base R                        | Improves modularity, readability, and testability                                | `my_function <- function(x) { ... }`                                    |
| **Write unit tests early**             | `testthat` (R), `pytest`      | Ensure correctness and avoid regression bugs                                     | `testthat::test_that("works", expect_equal(...))`                       |
| **Document everything**                | `roxygen2`, `README.md`       | Generate help files and keep user guidance up to date                            | `#' @param x numeric` → `roxygen2::roxygenise()`                        |
| **Use version control**                | Git, GitHub, GitLab           | Track changes, collaborate, and revert mistakes                                  | `git commit -m "added feature"` / `git push`                            |
| **Use reproducible environments**      | `renv` (R), `conda`, `Docker` | Lock dependencies to specific versions for reliable reuse                        | `renv::snapshot()` / `conda env export > env.yml`                       |
| **Automate repetitive tasks**          | `Make`, `targets` (R)         | Reproducible pipelines, avoid re-running unnecessary steps                       | `targets::tar_make()`                                                   |
| **Write vignettes and examples**       | `pkgdown`, `knitr`            | Helps users and collaborators understand how to use your software                | `usethis::use_vignette("myworkflow")`                                   |
| **Use CI/CD for testing**              | GitHub Actions                | Automatically run tests and checks on push or PR                                 | `.github/workflows/R-CMD-check.yaml` + `testthat`                       |
| **Package your code**                  | `usethis`, `devtools`         | Turn scripts into installable, documented R packages                             | `usethis::create_package("myPkg")`                                      |
| **Handle errors gracefully**           | `tryCatch`, assertions        | Improve user experience and debugging                                            | `stopifnot(is.numeric(x))` / `tryCatch({...}, error=function(e) {...})` |
| **Use type checking where possible**   | `checkmate`, `assertthat`     | Enforce expected input types and structure                                       | `checkmate::assert_numeric(x)`                                          |
| **Provide licensing and citation**     | `usethis`, `citation()`       | Ensures credit and legal clarity for reuse                                       | `usethis::use_mit_license("Your Name")` / `citation("yourPkg")`         |

---

> **Note:** Many of these tools and practices are applicable across programming languages, but R has a particularly rich ecosystem tailored to open, reproducible, and FAIR research.
