# Bi1121c - Protein Interaction Network Analysis
# This script loads protein data, cleans it, retrieves interaction and localization info,
# builds a network, and saves a plot. Refactored for clarity and modularity.

# ---- Package Setup ----
# Uncomment to install required packages if needed
# install.packages(c('devtools', 'tidybiology', 'dplyr', 'tidyr', 'plyr', 'igraph', 'ggraph', 'ggplot2', 'UniprotR'))
# install.packages('BiocManager')
# BiocManager::install(c('Biostrings', 'GenomicAlignments'))

library(devtools)
library(tidybiology)
library(plyr)
library(dplyr)
library(tidyr)
library(igraph)
library(ggraph)
library(ggplot2)
library(UniprotR)

# ---- Data Preparation Functions ----

#' Clean protein data: remove columns with many NAs and drop rows with any NA
clean_protein_data <- function(proteins) {
  proteins %>%
    select(-c('gene_name_alt', 'protein_name_alt')) %>%
    drop_na()
}

#' Retrieve and merge protein interactions and functions
get_protein_annotations <- function(subset) {
  interactions <- UniprotR::GetProteinInteractions(subset$uniprot_id)
  functions <- UniprotR::GetProteinFunction(subset$uniprot_id)
  interactions$uniprot_id <- rownames(interactions)
  functions$uniprot_id <- rownames(functions)
  plyr::join_all(list(subset, interactions, functions), by = 'uniprot_id')
}

#' Create edge list from merged annotation data
create_edge_list <- function(merged) {
  merged %>%
    mutate(targets = strsplit(as.character(Interacts.with), ";")) %>%
    unnest(targets) %>%
    mutate(targets = trimws(targets)) %>%
    select(uniprot_id, target = targets) %>%
    drop_na() %>%
    rename("from" = "uniprot_id", "to" = "target")
}

#' Retrieve and process subcellular locations for a set of protein IDs
get_location_matrix <- function(all_ids, possible_locations) {
  locations <- UniprotR::GetSubcellular_location(all_ids)
  locations$uniprot_id <- rownames(locations)
  locations <- locations %>%
    mutate(loc = trimws(strsplit(Subcellular.location..CC., "[.]")))
  location_matrix <- sapply(possible_locations, function(x) grepl(x, locations$loc))
  bind_cols(select(locations, uniprot_id, Subcellular.location..CC.), as.data.frame(location_matrix))
}

#' Assign a unique color code to each location combination
assign_location_colors <- function(locations, possible_locations) {
  locations$color <- as.factor(
    as.integer(
      interaction(
        locations[, possible_locations], drop = TRUE
      )
    )
  )
  locations
}

#' Determine co-localization for each edge based on matching locations
determine_colocation <- function(edge_loc_data, location_cols) {
  # For each location, compare *_from and *_to columns
  matches <- sapply(location_cols, function(loc) {
    from_col <- paste0(loc, "_from")
    to_col <- paste0(loc, "_to")
    edge_loc_data[[from_col]] == edge_loc_data[[to_col]]
  })
  # TRUE if any location matches for the edge
  apply(matches, 1, any)
}

# ---- Main Analysis ----

# Load proteins dataset
data(proteins, package = "tidybiology")

# Data checks (optional, for exploration)
stopifnot(nchar(proteins$sequence[1]) == proteins$length[1])
stopifnot(all(nchar(proteins$sequence) == proteins$length))
cat("Any NA in proteins:", any(is.na(proteins)), "\n")
na_idx <- data.frame(which(is.na(proteins), arr.ind = TRUE))
hist(na_idx$col, breaks = seq(0, 8), main = "NA Distribution by Column")

# Clean data
proteins_clean <- clean_protein_data(proteins)

# Plot length vs mass (exploratory)
plot(proteins_clean$length, proteins_clean$mass, main = "Protein Length vs Mass")

# Sample a subset of proteins for analysis
set.seed(42)
protein_subset <- slice_sample(proteins_clean, n = 20)

# Retrieve and merge annotations
annotations_merged <- get_protein_annotations(protein_subset)

# Build edge list for network
edges <- create_edge_list(annotations_merged)
all_protein_ids <- unique(c(edges$from, edges$to))

# Define locations of interest
locations_of_interest <- c('Nucleus', 'Cytoplasm', 'Vesicule', 'Mitochondrion')

# Retrieve and process subcellular locations
locations <- get_location_matrix(all_protein_ids, locations_of_interest)
locations <- assign_location_colors(locations, locations_of_interest)

# Build igraph object
protein_graph <- graph_from_data_frame(
  edges,
  vertices = locations,
  directed = FALSE
)

# Merge edge and location data for co-localization analysis
edge_loc_data <- edges %>%
  left_join(locations, by = c("from" = "uniprot_id")) %>%
  left_join(locations, by = c("to" = "uniprot_id"), suffix = c("_from", "_to"))


# Determine co-localization for all locations of interest
colocated <- determine_colocation(edge_loc_data, locations_of_interest)

# ---- Plotting ----

#' Plot and save the protein interaction network
plot_and_save_network <- function(graph, colocated, filename = "protein_network_plot.png") {
  plot_obj <- ggraph(graph, layout = "fr") +
    geom_edge_link(
      aes(color = colocated),
      width = 0.5, alpha = 0.6
    ) +
    geom_node_point(
      aes(color = color),
      size = 3,
      show.legend = TRUE
    ) +
    geom_node_text(
      aes(label = name),
      repel = TRUE,
      size = 3,
    ) +
    scale_edge_color_manual(
      values = c("grey80", "tomato"),
      labels = c("Different", "Same"),
      name = "Co-localization"
    ) +
    labs(title = "Protein Interaction Network Colored by Localization") +
    theme_void()
  ggsave(filename, plot = plot_obj, width = 8, height = 6, dpi = 300)
  plot_obj
}

# Generate and save the plot
plot_and_save_network(protein_graph, colocated)