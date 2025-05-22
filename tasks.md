# Bi1121c - Introduction to Research Software Engineering

## Instructions

In this project, you will explore and analyze protein interaction networks using R. The repository demonstrates best practices in research software engineering, including modular code, explicit data handling, command-line interfaces, and unit testing.

You will work through several stages, each introducing new aspects of research software engineering:

### Stages

1. **Interactive Session**  
   Start by exploring and analyzing protein datasets interactively in R or RStudio.  
   - **Load and inspect the dataset:**  
     Use the `tidybiology` package to load a protein dataset. Explore its structure, check for missing values, and understand the available columns (such as UniProt IDs, gene names, sequence, etc.).
   - **Perform basic data cleaning and exploration:**  
     Remove or impute missing values, filter for relevant proteins, and select columns of interest. Summarize the data (e.g., distributions of protein lengths or masses).
   - **Create simple plots:**  
     Visualize the data using boxplots, scatterplots, or histograms (e.g., protein length vs. mass, or age distributions).
   - **Query UniProt for additional information:**  
     Use the `UniprotR` package to fetch protein interaction partners, functional annotations, and subcellular localization for a subset of proteins (e.g., a random sample of UniProt IDs).
   - **Build a protein interaction network:**  
     Construct an edge list from the interaction data, and use the `igraph` package to create a network object. Add node attributes such as subcellular localization.
   - **Visualize the protein network:**  
     Use `ggraph` or `igraph` plotting functions to visualize the network, coloring nodes by localization or other attributes, and highlighting co-localized interactions.

2. **RMarkdown Document**  
   Document your workflow and results in an RMarkdown file for reproducibility and sharing.
   - **Document each code cell:**  
     Add clear, concise explanations before each code chunk describing its purpose and expected output.
   - **Organize code in logical blocks:**  
     Group related steps together (e.g., data loading, cleaning, visualization, network analysis) and use section headers to separate them.
   - **Print relevant outputs and plots:**  
     Ensure that each important result (summaries, tables, plots, network diagrams) is printed or displayed, and briefly interpret the results in the text.
   - **Reflect on best practices:**  
     Comment on how code organization, documentation, and explicit outputs improve reproducibility and clarity.

3. **Executable R Script**  
   Progressively refactor your analysis into executable scripts:
   - **Step 1: Monolithic Script (`02_script.R`)**  
     Start with a single script where all code is executed in one go, without functions. This script should run the entire workflow from data loading to visualization in a linear fashion.
   - **Step 2: Partial Refactoring**  
     Begin extracting repeated or logically grouped code into functions within the same script. This improves readability and reusability, but function documentation and naming may still be minimal.
   - **Step 3: Full Refactoring (`03_refactored.R`)**  
     Refactor your script into a fully modular version:
     - Use functions for each logical step (data cleaning, annotation, plotting, etc.).
     - Add docstrings to all functions.
     - Choose clear, descriptive variable and function names.
     - Ensure the script is easy to read, maintain, and extend.

4. **R Script with Command Line Arguments**  
   Create a command-line tool (see `04b_cli.R`) that:
   - Accepts input files (e.g., a CSV of UniProt IDs) and output paths as arguments.
   - Allows customization of analysis parameters (e.g., subcellular locations).
   - Produces publication-quality plots and outputs.

5. **Unit Testing and Best Practices**  
   Add unit tests for your functions (see examples in `code_examples.R`).
   - Demonstrate the importance of explicit code, good naming, and testability.
   - Show how to catch subtle bugs with tests.

6. **(Bonus) R Package**  
   Optionally, organize your code as an installable R package for reuse and sharing.

---

## Example Workflow

1. **Generate a CSV of UniProt IDs**  
   Use R to sample IDs from a protein dataset and write to `uniprot_ids.csv`.

2. **Run the Command-Line Analysis**  
   ```sh
   Rscript 04b_cli.R uniprot_ids.csv output_plot.png --locations Nucleus Cytoplasm
   ```

## Help

### Explore and Test Code
Review `code_examples.R` for best practices in R coding and testing.

### Getting Help & Solutions

If you need help with any of the tasks or run into issues:

#### Ask for help
Visit the [GitHub repository](https://github.com/your-org/your-repo) and [create an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/creating-an-issue) describing your problem or question.

- See the [GitHub documentation on creating issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/creating-an-issue) for a step-by-step guide.
- You can also check [existing issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/viewing-your-issues) to see if your question has already been answered.

#### Find solutions
Example solutions for each task and stage are provided in the repository files:

- `02_script.R`, `03_refactored.R`, `04b_cli.R`, and `code_examples.R`

Review these files to compare your approach or to get unstuck.

If you are unsure how to proceed, don't hesitate to reach out via GitHub issues—help is available!

---

*See the README for more details and example commands.*