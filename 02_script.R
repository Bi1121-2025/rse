# Install required packages if not already installed
# install.packages('devtools')
# install.packages('tidybiology')
# install.packages('dplyr')
# install.packages('tidyr')
# install.packages('plyr')
# install.packages('igraph')
# install.packages('ggraph')
# install.packages('ggplot2')
# install.packages('UniprotR')
# install.packages('BiocManager')
# BiocManager::install('Biostrings')
# BiocManager::install('GenomicAlignments')

# Load libraries
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

# Load proteins dataset
data(proteins, package = "tidybiology")

# Data checks
print(nchar(proteins$sequence[1]) == proteins$length[1])
print(all(nchar(proteins$sequence) == proteins$length))
print(any(is.na(proteins)))
na_idx <- data.frame(which(is.na(proteins), arr.ind=TRUE))
hist(na_idx$col, breaks = seq(0,8))

# Remove columns with many NAs and drop remaining NA rows
prot_cleaned <- dplyr::select(proteins, -c('gene_name_alt','protein_name_alt'))
prot_cleaned_no_na <- tidyr::drop_na(prot_cleaned)

# Plot length vs mass
plot(prot_cleaned_no_na$length, prot_cleaned_no_na$mass)

# Create a subset of protein ids
set.seed(42)
subset <- dplyr::slice_sample(prot_cleaned_no_na, n=20)

# Retrieve protein interactions, functions, and locations
interactions <- UniprotR::GetProteinInteractions(subset$uniprot_id)
functions <- UniprotR::GetProteinFunction(subset$uniprot_id)

# Add uniprot_id column
interactions$uniprot_id <- rownames(interactions)
functions$uniprot_id <- rownames(functions)

# Merge datasets
datasets <- list(subset, interactions, functions)
merged <- plyr::join_all(datasets, by='uniprot_id')

# Create edge list
edges <- merged |>
  dplyr::mutate(targets = strsplit(as.character(Interacts.with), ";")) |>
  tidyr::unnest(targets) |>
  dplyr::mutate(targets = trimws(targets)) |>
  dplyr::select(uniprot_id, target = targets) |>
  tidyr::drop_na() |>
  dplyr::rename('from' = 'uniprot_id', 'to' = 'target')

all_ids <- unique(c(edges$from, edges$to))

# Get subcellular locations
locations <- UniprotR::GetSubcellular_location(all_ids)
locations$uniprot_id <- rownames(locations)

# Parse locations
locations <- locations |>
  dplyr::mutate(loc = trimws(strsplit(Subcellular.location..CC., "[.]")))

# Define possible locations
possible_locations <- c('Nucleus', 'Cytoplasm', 'Vesicule', 'Mitochondrion')

# Create logical columns for each location
result <- sapply(possible_locations, function(x) grepl(x, locations$loc))
locations <- locations |> dplyr::select(uniprot_id, Subcellular.location..CC.) |> dplyr::bind_cols(result)

# Build igraph object
graph <- igraph::graph_from_data_frame(
  edges,
  vertices = locations,
  directed = FALSE
)

# Merge interaction, localization, and function data
combined_data <- edges |>
  dplyr::left_join(locations, by = c("from" = "uniprot_id")) |>
  dplyr::left_join(locations, by = c("to" = "uniprot_id"), suffix = c("_from", "_to"))

# Determine co-localization
colocated <- combined_data$Nucleus_from == combined_data$Nucleus_to  |
  combined_data$Cytoplasm_from == combined_data$Cytoplasm_to |
  combined_data$Vesicule_from == combined_data$Vesicule_to |
  combined_data$Mitochondrion_from == combined_data$Mitochondrion_to

# Assign color based on location combination
locations$color <- as.factor(
  as.integer(
    interaction(
      locations$Nucleus, locations$Cytoplasm, locations$Vesicule, locations$Mitochondrion
    )
  )
)

# Rebuild graph with color attribute
graph <- igraph::graph_from_data_frame(
  edges,
  vertices = locations,
  directed = FALSE
)

# Plot and save to file
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

ggsave("protein_network_plot.png", plot = plot_obj, width = 8, height = 6, dpi = 300)