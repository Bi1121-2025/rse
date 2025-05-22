# Bi1121c - Protein Interaction Network Analysis
# This script loads protein data, cleans it, retrieves interaction and localization info,
# builds a network, and saves a plot. Refactored for clarity and modularity.

# ---- Package Setup ----
# Uncomment to install required packages if needed
# install.packages(c('devtools', 'tidybiology', 'dplyr', 'tidyr', 'plyr', 'igraph', 'ggraph', 'ggplot2', 'UniprotR', 'argparse'))
# install.packages('BiocManager')
# BiocManager::install(c('Biostrings', 'GenomicAlignments'))

suppressPackageStartupMessages({
  library(devtools)
  library(tidybiology)
  library(plyr)
  library(dplyr)
  library(tidyr)
  library(igraph)
  library(ggraph)
  library(ggplot2)
  library(UniprotR)
  library(argparse)
})

# ---- Data Preparation Functions ----

#' Retrieve and merge protein interactions and functions
get_protein_interactions <- function(ids) {
  interactions <- UniprotR::GetProteinInteractions(ids)
  interactions$uniprot_id <- rownames(interactions)
  interactions
}

#' Create edge list from merged annotation data
create_edge_list <- function(protein_interactions) {
  protein_interactions %>%
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

#' Convert columns to a unique factor
as.enumerate <- function(x) {
  as.factor(as.integer(interaction(x, drop = TRUE)))
}

#' Assign a unique color code to each location combination
assign_location_colors <- function(locations, possible_locations) {
  locations$color <- as.enumerate(locations[, possible_locations])
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

# ---- Main Analysis ----

# Argument parsing using argparse
parser <- ArgumentParser(description = "Protein Interaction Network Analysis")
parser$add_argument("uniprot_id_file", help = "Path to CSV file with UniProt IDs")
parser$add_argument("output_plot_file", help = "Path to output PNG plot file")
parser$add_argument(
  "--locations",
  nargs = "+",
  default = c('Nucleus', 'Cytoplasm', 'Vesicule', 'Mitochondrion'),
  help = "List of subcellular locations of interest (default: Nucleus Cytoplasm Vesicule Mitochondrion)"
)
args <- parser$parse_args()

print(args$locations)

# Load UniProt IDs
uniprot_ids <- read.csv(args$uniprot_id_file, header = TRUE, stringsAsFactors = FALSE)$uniprot_id

# Retrieve and merge annotations
interactions <- get_protein_interactions(uniprot_ids)

# Build edge list for network
edges <- create_edge_list(interactions)
all_protein_ids <- unique(c(edges$from, edges$to))

# Define locations of interest
locations_of_interest <- args$locations

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

# Generate and save the plot to the specified output path
plot_and_save_network(protein_graph, colocated, filename = args$output_plot_file)