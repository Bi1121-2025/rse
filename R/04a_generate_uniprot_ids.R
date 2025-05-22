# Script to sample 20 random UniProt IDs from the tidybiology proteins dataset and write to CSV

library(tidybiology)

# Load the proteins dataset
data(proteins, package = "tidybiology")

# Sample 20 unique UniProt IDs
set.seed(42)
sampled_ids <- sample(unique(proteins$uniprot_id), 20)

# Write to CSV
write.csv(
  data.frame(uniprot_id = sampled_ids),
  file = "uniprot_ids.csv",
  row.names = FALSE,
  quote = FALSE
)