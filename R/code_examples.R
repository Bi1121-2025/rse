# Example: Good Variable and Function Names vs. Heavy Documentation

# --- Poor naming, heavy documentation (harder to read quickly) ---

#' Calculates the mean of positive values in a numeric vector.
#' @param a Numeric vector.
#' @return Mean of positive values.
f1 <- function(a) {
  b <- a[a > 0]
  c <- mean(b)
  return(c)
}

v1 <- c(-1, 2, 3, -4, 5)
result1 <- f1(v1)
print(result1)

# --- Good naming, minimal documentation (self-explanatory) ---

mean_of_positive_values <- function(numbers) {
  positive_numbers <- numbers[numbers > 0]
  mean(positive_numbers)
}

values <- c(-1, 2, 3, -4, 5)
result2 <- mean_of_positive_values(values)
print(result2)

# The second example is easier to understand at a glance, even without comments.


# Example: "Smart" code vs. explicit code

# --- "Smart" code: tries to handle everything automatically, but hides intent ---
# This function tries to handle both numeric and character input "smartly"
smart_mean <- function(x) {
  if (is.character(x)) x <- as.numeric(x)
  mean(x, na.rm = TRUE)
}

print(smart_mean(c("1", "2", "oops", "4")))  # Returns NA, but silently ignores the error

# --- Explicit code: checks input and fails clearly if expectations are not met ---
explicit_mean <- function(x) {
  if (!is.numeric(x)) stop("Input must be numeric.")
  mean(x, na.rm = TRUE)
}

# This will stop with a clear error if input is not numeric
# print(explicit_mean(c("1", "2", "oops", "4")))  # Uncomment to see the error

print(explicit_mean(c(1, 2, 4)))  # Works as expected

# Being explicit makes code safer and easier to debug, as failures are clear and expectations are documented.

library(readr)
library(ggplot2)

# Example data as CSV (could be in a file "samples.csv")
csv_text <- "sample_id,condition,age
1,control,34
2,treated,29
3,control,41
4,treated,35
5,control,38
6,treated,32
7,control,36
8,treated,30
"

# Write example to a file for demonstration
writeLines(csv_text, "samples.csv")

# --- "Smart" code: uses column indices (fragile) ---
# This code assumes that the second column is always 'condition' and the third is 'age'.
# If the column order changes or the file structure is different, the plot will be wrong or error-prone.
# Also, loading any table without specifying column types/names can lead to subtle bugs.
smart_df <- readr::read_csv("samples.csv")
ggplot(smart_df, aes(x = smart_df[[2]], y = smart_df[[3]], fill = smart_df[[2]])) +
  geom_boxplot() +
  labs(title = "Age Distribution per Condition (by index)", x = "condition", y = "age") +
  theme_minimal()

# --- Explicit code: uses column names (robust and readable) ---
# This code explicitly sets the expected column names and types.
# It is robust to column order and will fail clearly if the file format is not as expected.
# Using column names in ggplot makes the code much easier to read and maintain.
explicit_df <- readr::read_csv(
  "samples_wrong.csv",
  col_select = c("sample_id", "condition", "age"),
  col_types = cols(
    sample_id = col_integer(),
    condition = col_character(),
    age = col_double()
  )
)
ggplot(explicit_df, aes(x = condition, y = age, fill = condition)) +
  geom_boxplot() +
  labs(title = "Age Distribution per Condition (by name)", x = "condition", y = "age") +
  theme_minimal()

# Clean up example file
file.remove("samples.csv")

library(testthat)

#' Convert columns to a unique factor
as.enumerate <- function(x) {
  as.factor(as.integer(interaction(x, drop = TRUE)))
}

test_that("as.enumerate assigns unique integer factors for unique combinations", {
  
  # arrange: create a data frame with two logical columns and expected output
  df <- data.frame(
    A = c(TRUE, TRUE, FALSE, FALSE, TRUE),
    B = c(TRUE, FALSE, TRUE, FALSE, TRUE)
  )
  expected <- c(4, 2, 3, 1, 4)
  
  actual <- as.enumerate(df) # act: system under test

  expect_equal(length(unique(actual)), 4)       # assert: There are 4 unique combinations, so levels should be 1:4
  expect_equal(as.integer(actual), expected)    # assert: Same combinations should have the same value
})