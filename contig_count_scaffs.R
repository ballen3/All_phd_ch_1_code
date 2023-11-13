# Load the required library
library(ggplot2)

# Specify the path to your CSV file
csv_file <- "~/Research/ch_01/contig_count_summary.csv"  # Replace with your actual file path

# Read the CSV data
data <- read.csv(csv_file)

# Create a bar plot
ggplot(data, aes(x = factor(ID), y = contig_count)) +
  geom_bar(stat = "identity", fill = "pink") +
  labs(title = "Contig Bar Plot", x = "ID", y = "#contig") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis labels if needed



