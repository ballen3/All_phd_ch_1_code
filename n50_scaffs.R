# Load the required library
library(ggplot2)

# Specify the path to your CSV file
# This is still missing 17 of the 266 files (total of 249 here)
csv_file <- "~/Research/ch_01/N50_summary.csv"  # Replace with your actual file path

# Read the CSV data
data <- read.csv(csv_file)

# Create a bar plot
ggplot(data, aes(x = factor(ID), y = N50)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "N50 Bar Plot", x = "ID", y = "N50") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis labels if needed

## Higher N50 is generally better