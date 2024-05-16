#install.packages("broom")
library(ggplot2)
library(dplyr)
library(ggcorrplot)
library(tidyverse)
library(broom)
#library(reshape2)
library(vegan)
library(ellipse)
library(sf)
library(mapview)
library(fs)
library(sm)
library(pals)

## Data
#setwd("D:/PhD_ch1_stuff/")
## Read Bigscape Network Table (csv) in
mydata <- read.csv("D:/PhD_ch1_stuff/new_assemblies/R_analysis_things/mix_network_table_updated_metadata.csv")

### Fixing a row that was missing a State value and the 3 MiBIG BGCs also
## Find the row index where shared.name is equal to the specified value
#row_index <- which(mydata$shared.name == "BGC0002476")
## Update the value in the 'state' column for the found row
#mydata[row_index, "State"] <- "N/A"

########################### Misc GCF Stuff ###########################
#Number of genomes for a country by number of GCFs for a country
  # Counting all GCFs (includes duplicates)
country_gcfs <- mydata %>%
  group_by(Country, Family.Number) %>%
  summarise(Count = n()) %>%
  ungroup() %>%
  group_by(Country) %>%
  summarise(Total_gcf_Count = sum(Count)) %>%
  subset(Total_gcf_Count != 3)
country_gcfs <- country_gcfs[, -1]

#sorting and counting unique GCFs only for a country
country_unique_gcfs <- mydata %>%
  group_by(Country, Family.Number) %>%
  summarise() %>%
  ungroup() %>%
  count(Country) %>%
  rename(Total_unique_gcf_Count = n)%>%
  subset(Total_unique_gcf_Count != 3)
country_unique_gcfs <- country_unique_gcfs[, -1]
country_unique_gcfs_matrix <- as.matrix(country_unique_gcfs)


# Build the dataframes
#Number of genomes per country
genome_country_count <- c(20, 33, 8, 62, 3, 17, 11, 1, 1, 2, 14, 31, 10, 2, 1, 1, 1, 40)
#Countries (corresponding to Number of genomes per country (above))
Countries <- c('Argentina', 'Australia', 'Austria', 'Belgium','Canada','Chile','Estonia','France','Germany','Italy','Japan','New Zealand','Norway','Russia','Sweden','Taiwan','Tanzania','USA')
# Build the dataframes
gcf_genome_df <- data.frame(Countries, genome_country_count,country_gcfs)
unique_gcf_genome_df <- data.frame(Countries, genome_country_count,country_unique_gcfs)


# Scatter plot with trend line
ggplot(gcf_genome_df, aes(x = genome_country_count, y = Total_gcf_Count, color = Countries)) +
  geom_point(size=4) +  # Scatter plot
  geom_smooth(method = "lm", se = FALSE) +  # Trend line
  labs(x = "Number of Genomes Sampled", y = "Total GCF Count", title = "Scatter Plot of GCF Counts") +
  theme_minimal()

# Scatter plot with trend line
ggplot(unique_gcf_genome_df, aes(x = genome_country_count, y = Total_unique_gcf_Count, color = Countries)) +
  geom_point(size=4) +  # Scatter plot
  geom_smooth(method = "lm", se = FALSE) +  # Trend line
  labs(x = "Number of Genomes Sampled", y = "Total unique GCF Count", title = "Scatter Plot of Unique GCF Counts") +
  theme_minimal()

###########################.

########################### Cluster Stats ###########################
# Data transformation #1 (getting the count and percentages of the BGC classes)
dfa <- mydata %>% 
  group_by(BiG.SCAPE.class) %>% # Variable to be transformed
  count() %>% 
  ungroup() %>% 
  mutate(perc = `n` / sum(`n`)) %>% 
  arrange(perc) %>%
  mutate(labels = scales::percent(perc))

# Plot the number of clusters per BGC class (with percentages inside each bar)
pa <- ggplot(dfa, aes(x = BiG.SCAPE.class, y = n, fill = BiG.SCAPE.class)) +
  geom_bar(stat = "identity") + 
  theme_minimal() +
  geom_text(aes(label = labels), vjust = -0.2, color = "black", size = 4) +
  labs(y = "Number of Clusters", x = "BGC Classes") +
  theme(
    panel.background = element_blank(),
    plot.background = element_rect(fill = "transparent", colour = NA),
    axis.line = element_line(colour = "black"), # Adjust the color of axis lines
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels by 45 degrees
    axis.text = element_text(colour = "black", size = 15),
    axis.title = element_text(size = 20, colour = "black"),
    legend.title = element_text(size = 15, colour = "black"),
    legend.text = element_text(size = 15, colour = "black"),
    panel.grid.major = element_blank(), # Remove major grid lines
    panel.grid.minor = element_blank()  # Remove minor grid lines
  ) +
  theme(legend.position = "none")  # Remove legend
print(pa)

# Proportion of BGCs 
#(relative abundance of BGCs per genome in each population compared to the average abundance across all populations.)
avg_bgc_per_genome <- (8238/258)
#introduced
int_bgc_per_genome <- (4667/145)
#native
nat_bgc_per_genome <- (3571/113)

# Count the number of occurrences of each Genome.ID and group by Status
num_bgcs <- mydata %>%
  group_by(Genome.ID, Status) %>%
  summarise(num.bgcs = n())
# Remove the the 3 MiBig Clusters (again)
num_bgcs <- subset(num_bgcs, num.bgcs != 3)

# Checking for normal distribution of BGC/genome
# Filter the data for Native and Introduced Status
native_data <- num_bgcs[num_bgcs$Status == "Native", ]
introduced_data <- num_bgcs[num_bgcs$Status == "Introduced", ]

# Plot histogram for Native Status
ggplot(native_data, aes(x = num.bgcs, fill = Status)) +
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.5) +
  labs(x = "Number of BGCs", y = "Frequency", title = "Histogram of Number of BGCs for Native Status") +
  scale_fill_manual(values = "blue") +
  theme_minimal()

# Plot histogram for Introduced Status
ggplot(introduced_data, aes(x = num.bgcs, fill = Status)) +
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.5) +
  labs(x = "Number of BGCs", y = "Frequency", title = "Histogram of Number of BGCs for Introduced Status") +
  scale_fill_manual(values = "red") +
  theme_minimal()

# Shapiro-Wilk test for Native Status
shapiro_test_native <- shapiro.test(native_data$num.bgcs)
print(shapiro_test_native)

# Shapiro-Wilk test for Introduced Status
shapiro_test_introduced <- shapiro.test(introduced_data$num.bgcs)
print(shapiro_test_introduced)

wilcox_test_result <- wilcox.test(num.bgcs ~ Status, data = num_bgcs)
print(wilcox_test_result)
#######################################################################.

########################### NATIVE VS INTRODUCED ###########################
#Data transformation #2 (Calculate total counts for each BiG.SCAPE.class within each Status)
class_status_counts <- mydata %>%
  group_by(BiG.SCAPE.class, Status) %>%
  summarize(class_status_count = n())
# Remove the 3 MiBiG Clusters
class_status_counts <- subset(class_status_counts, class_status_count != 1)


# Calculate total counts for each Status
status_total_counts <- mydata %>%
  group_by(Status) %>%
  summarize(total_count = n())
status_total_counts <- status_total_counts[status_total_counts$Status != "", ]
# Remove the the 3 MiBig Clusters (again)
status_total_counts <- subset(status_total_counts, total_count != 3)

# Merge the data frames to get the total count for each Status in the class_status_counts
class_status_counts <- merge(class_status_counts, status_total_counts, by = "Status")
# Create new rows for PKS-NRP_Hybrids and PKSother classes
new_rows <- data.frame(
  BiG.SCAPE.class = c("PKS-NRP_Hybrids", "PKSother"),
  Status = c("Native", "Native"),
  class_status_count = c(0, 0),
  total_count = c(3571, 3571)
)
# Add the new rows to the data frame
class_status_counts <- rbind(class_status_counts, new_rows)
# Calculate the proportion for each BiG.SCAPE.class within each Status
class_status_counts <- class_status_counts %>%
  mutate(proportion = class_status_count / total_count)

#Plot the normalized proportion of clusters per BGC class for native and introduced populations
pb <- ggplot(class_status_counts, aes(x = BiG.SCAPE.class, y = proportion, fill = Status)) + 
  geom_bar(stat = "identity", position = "dodge", color = "black") +  # Side-by-side bars
  scale_fill_manual(values = c("Introduced" = "#DDAA33", "Native" = "#BB5566")) +  # Specify custom colors
  labs(y = "Proportion of BGCs", x = "BGC Classes") +
  theme(
    panel.background = element_blank(),
    plot.background = element_rect(fill = "transparent", colour = NA),
    axis.line = element_line(colour = "black"), # Adjust the color of axis lines
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate x-axis labels by 45 degrees
    axis.text = element_text(colour = "black", size = 20),
    axis.title = element_text(size = 30, colour = "black"),
    legend.title = element_text(size = 15, colour = "black"),
    legend.text = element_text(size = 15, colour = "black")
  )
print(pb)

# 2 proportion z test (95 percent confidence interval) to compare proportion of BGC classes between native and introduced pops
#Other, PKS1, and Ripps are significant at P=0.05
NRPS_z <- prop.test(x = c(1177, 930), n = c(4667, 3571))
#NRPS_z (X-squared = 0.67813, df = 1, p-value = 0.4102)
others_z <- prop.test(x = c(1363, 972), n = c(4667, 3571))
#others_z (X-squared = 3.8307, df = 1, p-value = 0.05032)* (Introduced is higher)
PKS_NRPS_hybs_z <- prop.test(x = c(2, 0), n = c(4667, 3571))
#PKS_NRPS_hybs_z (X-squared = 0.27424, df = 1, p-value = 0.6005)
PKS1_z <- prop.test(x = c(175, 187), n = c(4667, 3571))
#PKS1_z (X-squared = 10.295, df = 1, p-value = 0.001334)* (Native is higher)
PKSother_z <- prop.test(x = c(2, 0), n = c(4667, 3571))
#PKSother_z (X-squared = 0.27424, df = 1, p-value = 0.6005)
Ripps_z <- prop.test(x = c(32, 12), n = c(4667, 3571))
#Ripps_z (X-squared = 4.02, df = 1, p-value = 0.04496)* (Introduced is higher)
terpene_z <- prop.test(x = c(1916, 1470), n = c(4667, 3571))
#terpene_z (X-squared = 0.0061828, df = 1, p-value = 0.9373)
print(NRPS_z)

# Count IsSingleNode values and proportions by Status to get the number of single nodes (bigscape)
node_data_summary <- mydata %>%
  group_by(IsSingleNode, Status) %>%
  summarise(count = n()) 

############################################################################.
########################### GCFs ###########################
# GCF abundance and relative abundance 
GCF_abundance <- mydata %>%
  count(Family.Number)
GCF_abundance <- GCF_abundance %>%
  mutate(GCF_abundance_relative = (n / 258) *100 )
# Remove the the 3 MiBig Clusters (again)
GCF_abundance_no_single <- subset(GCF_abundance, n != 1)

# Arrange the dataframe based on GCF_abundance_relative in descending order
GCF_abundance_no_single_ordered <- GCF_abundance_no_single[order(-GCF_abundance_no_single$GCF_abundance_relative),]
# Create a factor for Family.Number with levels ordered by abundance ranks
GCF_abundance_no_single_ordered$Family.Number <- factor(GCF_abundance_no_single_ordered$Family.Number, levels = GCF_abundance_no_single_ordered$Family.Number)
# Plot the bar graph for GCF abundance
ggplot(GCF_abundance_no_single_ordered, aes(x = Family.Number, y = GCF_abundance_relative)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  labs(x = "GCF", y = "% Genome Abundance") +
  theme(
    panel.background = element_blank(),
    plot.background = element_rect(fill = "transparent", colour = NA),
    axis.line = element_line(colour = "black"), # Adjust the color of axis lines
    axis.text = element_text(colour = "black", size = 5),
    axis.title = element_text(size = 30, colour = "black"),
    axis.text.y = element_text(size = 20, colour = "black"),
    panel.grid.major = element_blank(), # Remove major grid lines
    panel.grid.minor = element_blank(),  # Remove minor grid lines
    axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis labels for better readability
    

# Find the number of unique values in the Family.Number column (458)
unique_family_numbers <- unique(mydata$Family.Number)
num_unique_family_numbers <- length(unique_family_numbers)

# Calculate percentage of total genomes for each Family.Number
total_genomes <- 258
# Group the data by Family.Number and count the number of unique Genome.IDs
unique_genomes_per_family <- mydata %>%
  group_by(Family.Number) %>%
  summarise(num_unique_genomes = n_distinct(Genome.ID))
# calculate the % of genomes a GCF is found associated with
unique_genomes_per_family <- unique_genomes_per_family %>%
  mutate(percentage_of_total = (num_unique_genomes / total_genomes) * 100)

# Find unique Family.Numbers associated with Status Introduced (399)
introduced_family_numbers <- mydata %>%
  filter(Status == "Introduced") %>%
  pull(Family.Number) %>%
  unique()
# Find unique Family.Numbers associated with Status Native (314)
native_family_numbers <- mydata %>%
  filter(Status == "Native") %>%
  pull(Family.Number) %>%
  unique()
# Find Family.Numbers that are found only with Status Introduced and not with Status Native (144)
introduced_only_family_numbers <- setdiff(introduced_family_numbers, native_family_numbers) 
# Convert introduced_only_family_numbers to a dataframe
introduced_only_df <- data.frame(Family.Number = introduced_only_family_numbers)
# Find Family.Numbers that are found only with Status Native and not with Status Introduced (59)
native_only_family_numbers <- setdiff(native_family_numbers, introduced_family_numbers)
# Convert native_only_family_numbers to a dataframe
native_only_df <- data.frame(Family.Number = native_only_family_numbers)
# Find Family.Numbers that are found with both Status Introduced and Status Native (255)
common_family_numbers <- intersect(introduced_family_numbers, native_family_numbers)
# Convert common_family_numbers to a dataframe
common_family_numbers_df <- data.frame(Family.Number = common_family_numbers)

# Merge common_family_numbers_df with unique_genomes_per_family dataframe
common_family_numbers_df <- merge(common_family_numbers_df, unique_genomes_per_family, by = "Family.Number", all.x = TRUE)

# Merge native_only_df with unique_genomes_per_family dataframe
native_only_df <- merge(native_only_df, unique_genomes_per_family, by = "Family.Number", all.x = TRUE)
# Count rows with "1" for num_unique_genomes in native_only_df (48)
nat_only_singles <- sum(native_only_df$num_unique_genomes == 1)

# Merge introduced_only_df with unique_genomes_per_family dataframe
introduced_only_df <- merge(introduced_only_df, unique_genomes_per_family, by = "Family.Number", all.x = TRUE)
# Count rows with "1" for num_unique_genomes in introduced_only_df (134)
int_only_singles <- sum(introduced_only_df$num_unique_genomes == 1)




# Find Family.Numbers that are found only with Status Introduced and not with Status Native
introduced_only <- mydata %>%
  filter(Status == "Introduced") %>%
  anti_join(mydata %>% filter(Status == "Native"), by = "Family.Number") %>%
  summarise(Unique_GCFs = n_distinct(Family.Number))
# Find Family.Numbers that are found only with Status Native and not with Status Introduced
native_only <- mydata %>%
  filter(Status == "Native") %>%
  anti_join(mydata %>% filter(Status == "Introduced"), by = "Family.Number") %>%
  summarise(Unique_GCFs = n_distinct(Family.Number))
# Find Family.Numbers that are found with both Status Introduced and Status Native
both_status <- mydata %>%
  filter(Status %in% c("Introduced", "Native")) %>%
  group_by(Family.Number) %>%
  filter(n_distinct(Status) == 2) %>%
  summarise()
# Count the total number of Unique GCFs associated with both Status Introduced and Status Native
both_status <- nrow(both_status)
# Calculate the total number of unique GCFs
total_unique_GCFs <- n_distinct(mydata$Family.Number)
# Calculate the percentages
introduced_only_percent <- (introduced_only$Unique_GCFs / total_unique_GCFs) * 100
native_only_percent <- (native_only$Unique_GCFs / total_unique_GCFs) * 100
both_status_percent <- (both_status / total_unique_GCFs) * 100
# Create the bar plot
bar_data <- data.frame(
  Category = c("Introduced", "Native", "Both"),
  Percentage = c(introduced_only_percent, native_only_percent, both_status_percent)
)
# Reorder the categories for plotting
bar_data$Category <- reorder(bar_data$Category, -bar_data$Percentage)
bar_plot <- ggplot(bar_data, aes(x = Category, y = Percentage, fill = Category)) +
  geom_bar(stat = "identity") +
  labs(
       x = "GCF Population Status",
       y = "Percentage") +
  scale_fill_manual(values = c("Introduced" = "#DDAA33", "Native" = "#BB5566", "Both" = "#004488")) +
  theme_minimal() +
  theme(
    panel.background = element_blank(),
    plot.background = element_rect(fill = "transparent", colour = NA),
    axis.line = element_line(colour = "black"), # Adjust the color of axis lines
    axis.text = element_text(colour = "black", size = 20),
    axis.title = element_text(size = 30, colour = "black"),
    panel.grid.major = element_blank(), # Remove major grid lines
    panel.grid.minor = element_blank()  # Remove minor grid lines
  ) +
  theme(legend.position = "none")  # Remove legend
# Show the plot
print(bar_plot)

## GCF/Genome
unique_family_per_genome <- mydata %>%
  group_by(Genome.ID, Country) %>%
  summarise(Unique_Family_Number = n_distinct(Family.Number)) %>%
  ungroup()%>%
  subset(Unique_Family_Number != 3)



###########################.



########################### Most common GCFs ###########################
# Specify the Family.Numbers of interest
family_numbers_of_interest <- c(3071, 5626, 6141, 492, 2040, 7163)
# Filter mydata to extract rows with specified Family.Numbers
common_gcfs <- mydata %>%
  filter(Family.Number %in% family_numbers_of_interest)
# Calculate total counts (number of BGCs) for each Status for the top 6 most common (in >50% of genomes) GCFs
status_GCF_counts <- common_gcfs %>%
  group_by(Status) %>%
  summarize(total_count = n())
status_GCF_counts <- status_GCF_counts[status_GCF_counts$Status != "", ]
###########################.

########################### PCoA of GCF presence/absence (jaccard) for each GENOME ###########################
# Create gcf_diversity dataframe with Genome.ID, Status, and Country columns from mydata
gcf_diversity <- mydata %>%
  select(Genome.ID, Status, Country, Family.Number, Continent)
# Get unique Family.Number values from mydata
unique_families <- unique(mydata$Family.Number)
# Iterate over each unique Family.Number and create a column in gcf_diversity
for (family in unique_families) {
  # Create a new column with 1 if Genome.ID has a row with the Family.Number, else 0
  gcf_diversity <- gcf_diversity %>%
    mutate(!!paste0("Family_", family) := as.integer(Family.Number == family))
}
gcf_diversity <- gcf_diversity %>%
  select(-Family.Number)

# Group by Genome.ID and summarize all columns (merge GCF pres/abs for each genome)
gcf_diversity_merged <- gcf_diversity %>%
  group_by(Genome.ID, Status, Country, Continent) %>%
  summarise_all(.funs = function(x) if_else(any(x == 1), 1, 0))%>%
  filter(!is.na(Genome.ID))

# Remove metadata columns (Status,country, genome.ID and Continent) from gcf_diversity_merged
gcf_matrix <- gcf_diversity_merged[, !(names(gcf_diversity_merged) %in% c("Status", "Country", "Continent", "Genome.ID"))]


#run PCoA with Jaccard index
diss_matrix <- vegdist(gcf_matrix, method = "jaccard")
pcoa_results <- cmdscale(diss_matrix, eig = TRUE, k = 2)
pcoa_df <- as.data.frame(pcoa_results$points)
pcoa_df$Status <- gcf_diversity_merged$Status
pcoa_df$Country <- gcf_diversity_merged$Country
pcoa_df$Continent <- gcf_diversity_merged$Continent
pcoa_df$Genome.ID <- gcf_diversity_merged$Genome.ID

diss_matrix_metadata <- gcf_diversity_merged%>%
  select(Genome.ID, Status, Country, Continent)

pal.bands(alphabet, alphabet2, cols25, glasbey, kelly, polychrome, 
          stepped, tol, watlington,
          show.names=FALSE)  

# Plot the ggplot object (no ellipse)
pcoa_plotc <- ggplot(data = pcoa_df, aes(x = V1, y = V2, color = Country, shape = Status)) +
  geom_point(size = 3) +  # Increase point size
  scale_color_manual(values=as.vector(alphabet2(26))) +
  theme_minimal() +  # Minimal theme without background lines
  labs(x = "PCoA1", y = "PCoA2", color = "Country", shape = "Status") +  # Customize axis labels and legends
  theme(text = element_text(size = 15))  # Increase font size
# Plot the ggplot object
print(pcoa_plotc)

# Plot the ggplot object with ellipses using stat_ellipse (Country stressed)
#find centroid for Country
country_centroid <- pcoa_df%>%
  group_by(Country)%>%
  summarize(V1=mean(V1),V2=mean(V2))
#Significance of Status
adonis2(as.dist(diss_matrix)~diss_matrix_metadata$Country)
#plot it all together
pcoa_plot <- ggplot(data = pcoa_df, aes(x = V1, y = V2, color = Country, shape = Status)) +
  geom_point(size = 3) +  # Increase point size
  geom_point(data=country_centroid, size=5, shape=21, color="black",
             aes(fill=Country)) +
  stat_ellipse(level = 0.95, geom = "polygon", aes(fill = Country), alpha = 0.2) +  # Add ellipses with 95% confidence level
  theme_minimal() +  # Minimal theme without background lines
  labs(x = "PCoA1", y = "PCoA2", color = "Country", shape = "Status") +  # Customize axis labels and legends
  theme(text = element_text(size = 15))  # Increase font size
# Plot the ggplot object
print(pcoa_plot)


# Plot the ggplot object with ellipses using stat_ellipse (Status Stressed)
  #find centroid for status
status_centroid <- pcoa_df%>%
  group_by(Status)%>%
  summarize(V1=mean(V1),V2=mean(V2))
  #Significance of Status
adonis2(as.dist(diss_matrix)~diss_matrix_metadata$Status)
  #plot it all together
pcoa_plota <- ggplot(data = pcoa_df, aes(x = V1, y = V2, color = Status)) +
  geom_point(size = 3) +  # Increase point size
  geom_point(data=status_centroid, size=5, shape=21, color="black",
             aes(fill=Status)) +
  stat_ellipse(level = 0.95, geom = "polygon", aes(fill = Status), alpha = 0.2) +  # Add ellipses with 95% confidence level
  theme_minimal() +  # Minimal theme without background lines
  labs(x = "PCoA1", y = "PCoA2", color = "Status") +  # Customize axis labels and legends
  theme(text = element_text(size = 15))  # Increase font size
# Plot the ggplot object
print(pcoa_plota)

# Plot the ggplot object with ellipses using stat_ellipse (Continent Stressed)
  #find centroid for Continent
continent_centroid <- pcoa_df%>%
  group_by(Continent)%>%
  summarize(V1=mean(V1),V2=mean(V2))
#Significance of Status
adonis2(as.dist(diss_matrix)~diss_matrix_metadata$Continent)
#plot it all together
pcoa_plotb <- ggplot(data = pcoa_df, aes(x = V1, y = V2, color = Continent, shape = Status)) +
  geom_point(size = 3) +  # Increase point size
  geom_point(data=continent_centroid, size=5, shape=21, color="black",
             aes(fill=Continent)) +
  stat_ellipse(level = 0.95, geom = "polygon", aes(fill = Continent), alpha = 0.1) +  # Add ellipses with 95% confidence level
  theme_minimal() +  # Minimal theme without background lines
  labs(x = "PCoA1", y = "PCoA2", color = "Continent", shape = "Status") +  # Customize axis labels and legends
  theme(text = element_text(size = 15))  # Increase font size
# Plot the ggplot object
print(pcoa_plotb)

###########################.

########################### PCoA of GCF presence/absence with n>3 countries ##########################
# Calculate the number of points per Country group
point_counts <- pcoa_df %>%
  group_by(Country) %>%
  summarise(num_points = n())
# Filter out groups with fewer than 5 points
valid_countries <- point_counts %>%
  filter(num_points >= 3) %>%
  pull(Country)
# Filter the data based on valid Country groups
pcoa_df_filtered <- pcoa_df %>%
  filter(Country %in% valid_countries)

# Plot the ggplot object with filtered data
pcoa_2plot <- ggplot(data = pcoa_df_filtered, aes(x = V1, y = V2, color = Country, shape = Status)) +
  geom_point(size = 3) +  # Increase point size
  stat_ellipse(level = 0.95, geom = "polygon", aes(fill = Country), alpha = 0.2) +  # Add ellipses with 95% confidence level
  theme_minimal() +  # Minimal theme without background lines
  labs(x = "PCoA1", y = "PCoA2", color = "Country", shape = "Status") +  # Customize axis labels and legends
  theme(text = element_text(size = 15))  # Increase font size
# Plot the ggplot object
print(pcoa_2plot)

# Check for collinearity
cor_matrix <- cor(pcoa_df[, c("V1", "V2")])
print(cor_matrix)

##########################.
########################### Network Stats ###########################
# Calculate average degree for each unique Family.Number
avg_family_degree <- mydata %>%
  group_by(Family.Number) %>%
  summarise(avg_degree = mean(Degree, na.rm = TRUE))

# atromentin specific network
atro_data <- read.csv("D:/PhD_ch1_stuff/new_assemblies/mix_new/atromentin cluster default  node.csv")


###########################.
########################### Alpha diversity (looks pretty different between using Country and Locality- but the Locality metadata is...  messy) ###########################
alpha_df <- mydata %>%
  group_by(Genome.ID,Country,Locality, Family.Number, State) %>%
  summarise(GCF_Count = n()) %>%
  ungroup() %>%
  filter(Country != "")
# Create gcf_diversity dataframe with Genome.ID, Status, and Country columns from mydata
mydata %>%
  select(Genome.ID, Status, Country, Family.Number, Continent, State)

# functions to calculate alpha diversity (3 different metrics + the inverse of simpson later on)
richness <- function(x){
  sum(x > 0)
}
shannon <- function(x){
  rabund <- x[x>0]/sum(x)
  -sum(rabund * log(rabund))
}
simpson <- function(x){
  n <- sum(x)
  sum(x * (x-1) / (n * (n-1)))
} #this simpson calculation led to some weird plots so i swapped to the vegan one

# calculate the alpha diversity for the dataset- Grouped by Country
alpha_div_metrics_country <- alpha_df %>%
  group_by(Country) %>%
  summarize(richness = richness(GCF_Count),
            shannon = shannon(GCF_Count),
            simpson = diversity(GCF_Count, index="simpson"),
            invsimpson = 1/simpson,
            n_GCFs= sum(GCF_Count)) %>%
  pivot_longer(cols=c(richness,shannon,simpson,invsimpson),
               names_to = "metric") 
#Plot all of the metrics of alpha diversity for the actual dataset
ggplot(alpha_div_metrics_country ,aes(x=n_GCFs, y=value)) + #where n is the sum of number of GCFs 
  geom_point() +
  geom_smooth() +
  facet_wrap(~metric, nrow=4, scales="free_y")+
  ggtitle("Alpha Diversity Metrics Grouped by Country")

# calculate the alpha diversity for the dataset- Grouped by State
alpha_div_metrics_state <- alpha_df %>%
  group_by(State) %>%
  summarize(richness = richness(GCF_Count),
            shannon = shannon(GCF_Count),
            simpson = diversity(GCF_Count, index="simpson"),
            invsimpson = 1/simpson,
            n_GCFs= sum(GCF_Count)) %>%
  pivot_longer(cols=c(richness,shannon,simpson,invsimpson),
               names_to = "metric") 
#Plot all of the metrics of alpha diversity for the actual dataset- grouped by State
ggplot(alpha_div_metrics_state ,aes(x=n_GCFs, y=value)) + #where n is the sum of GCFs 
  geom_point() +
  geom_smooth() +
  facet_wrap(~metric, nrow=4, scales="free_y") +
  ggtitle("Alpha Diversity Metrics Grouped by State")

# random sampling of the pooled data- used to help check for influence of sampling effort
rand <- alpha_df %>%
  uncount(GCF_Count) %>%
  mutate(name= sample(Family.Number)) %>%
  count(Country, name, name = "GCF_Count")
# calcaulate the alpha diversity for the random sampling of the data
rand %>%
  group_by(Country) %>%
  summarize(richness = richness(GCF_Count),
            shannon = shannon(GCF_Count),
            simpson = diversity(GCF_Count, index="simpson"),
            invsimpson = 1/simpson,
            n_GCFs= sum(GCF_Count)) %>%
  pivot_longer(cols=c(richness,shannon,simpson,invsimpson),
               names_to = "metric")%>%
  ggplot(aes(x=n_GCFs, y=value)) + #where n is the sum of GCFs 
  geom_point() +
  geom_smooth() +
  facet_wrap(~metric, nrow=4, scales="free_y")

################.

########################### WIP! Beta diversity/Bray Curtis(?) (with rarefaction, but no removal of low count groups) for GCF diversity between Countries (sites) Group by Country and Family.Number, and summarize to count occurrences ###########################
beta_div_df <- mydata %>%
  group_by(Country, Family.Number) %>%
  summarise(GCF_Count = n()) %>%
  ungroup() %>%
  filter(Country != "") # Filter out rows with missing values in the "Country" column (This is from the MiBIG Clusters) 
  
# Total GCF_Count for each Country (to be used during rarefaction, did not remove any): lowest is Taiwan with 27 GCFs
beta_div_df %>%
  group_by(Country) %>%
  summarise(total = sum(GCF_Count))%>%
  arrange(total)
  
# Pivot the table to have Family.Number as columns
beta_div_df <- pivot_wider(beta_div_df, names_from = Family.Number, values_from = GCF_Count, values_fill = 0) 
# Extract the numerical column indices
numerical_columns <- sapply(beta_div_df, is.numeric)
# Rename the numerical columns by adding "GCF_" in front of each column name
names(beta_div_df)[numerical_columns] <- paste0("GCF_", names(beta_div_df)[numerical_columns])

# Remove the 'Country' column from the beta_div_df dataframe
beta_div_df_numeric <- beta_div_df[, -1]
beta_div_matrix <- as.matrix(beta_div_df_numeric)

## Need to check if everything after this point is right
# Calculate Bray-Curtis dissimilarity matrix, with rarefaction (to account for uneven sampling effort)
set.seed(19960606) #arbitrarily chosen number
bc_dist <- avgdist(beta_div_matrix, dmethod = "bray", sample=27)
set.seed(19960606)
bc_nmds <- metaMDS(bc_dist)

bc_dist_df <-as.data.frame(bc_dist)

# Combining nMDS points with country data
plot_bc_nmds <- data.frame(
  bc_nmds$points,
  Country = beta_div_df$Country)

# Plotting of nMDS: not sure if this makes sense to do. Doesnt seem like there's enough points
ggplot(plot_bc_nmds, 
       aes(x = MDS1, y = MDS2, color = Country)) +
  geom_point(size = 8) +
  coord_fixed() +
  theme_classic() +
  theme(legend.position = "right") 

# Calculate mean pairwise dissimilarity
mean_pairwise_dissimilarity <- mean(bc_dist)
# Print the result
print(mean_pairwise_dissimilarity)
################.

########################### Beta diversity/Bray Curtis(?) but with Genome (with rarefaction, but no removal of low count groups) for GCF diversity between Countries (sites) Group by Country and Family.Number, and summarize to count occurrences ################
b_div_genome_df <- mydata %>%
  group_by(Genome.ID, Family.Number, Country, Status) %>%
  summarise(GCF_Count = n()) %>%
  ungroup() %>%
  filter(Country != "") # Filter out rows with missing values in the "Country" column (This is from the MiBIG Clusters) 

# Total GCF_Count for each Country (to be used during rarefaction, did not remove any): lowest is Argentina with 25 GCFs
b_div_genome_df %>%
  group_by(Genome.ID, Family.Number, Country, Status) %>%
  summarise(total = sum(GCF_Count))%>%
  arrange(total)

# Pivot the table to have Family.Number as columns
b_div_genome_df <- pivot_wider(b_div_genome_df, names_from = Family.Number, values_from = GCF_Count, values_fill = 0) 
# Extract the numerical column indices
b_div_numerical_columns <- sapply(b_div_genome_df, is.numeric)
# Rename the numerical columns by adding "GCF_" in front of each column name
names(b_div_genome_df)[b_div_numerical_columns] <- paste0("GCF_", names(b_div_genome_df)[b_div_numerical_columns])

# Remove the 'Country' column from the beta_div_df dataframe
b_div_df_numeric <- b_div_genome_df[, -1]
b_div_matrix <- as.matrix(beta_div_df_numeric)

## Need to check if everything after this point is right
# Calculate Bray-Curtis dissimilarity matrix
bc_genome_dist <- avgdist(b_div_matrix, dmethod = "bray", 1)
bc_genome_dist_nmds <- metaMDS(bc_genome_dist)

bc_genome_dist_df <-as.data.frame(bc_genome_dist)

# Combining nMDS points with country data
bc_genome_dist_nmds <- data.frame(
  bc_genome_dist_nmds$points,
  Country = bc_genome_dist_df$Country)

# Plotting of nMDS: not sure if this makes sense to do. Doesnt seem like there's enough points
ggplot(plot_bc_nmds, 
       aes(x = MDS1, y = MDS2, color = Country)) +
  geom_point(size = 8) +
  coord_fixed() +
  theme_classic() +
  theme(legend.position = "right") 

# Calculate mean pairwise dissimilarity
mean_pairwise_dissimilarity <- mean(bc_dist)
# Print the result
print(mean_pairwise_dissimilarity)

###########################.

###### Beta diversity/Bray Curtis(?) (with rarefaction, but no removal of low count groups) for GCF diversity between Countries (sites)
########################### Group by Country and Family.Number, and summarize to count occurrences ###########################
mydata %>%
  group_by(Genome.ID, Country, Family.Number) %>%
  summarise(GCF_Count = n()) %>%
  ungroup() %>%
  filter(Country != "") # Filter out rows with missing values in the "Country" column (This is from the MiBIG Clusters) 

# Get unique Family.Number values from mydata
unique_families <- unique(mydata$Family.Number)
# Total GCF_Count for each Country (to be used during rarefaction, did not remove any): lowest is Taiwan with 27 GCFs
beta_div_df %>%
  group_by(Country) %>%
  summarise(total = sum(GCF_Count))%>%
  arrange(total)

# Pivot the table to have Family.Number as columns
beta_div_df <- pivot_wider(beta_div_df, names_from = Family.Number, values_from = GCF_Count, values_fill = 0) 
# Extract the numerical column indices
bnumerical_columns <- sapply(beta_div_df, is.numeric)
# Rename the numerical columns by adding "GCF_" in front of each column name
names(beta_div_df)[numerical_columns] <- paste0("GCF_", names(beta_div_df)[numerical_columns])

# Remove the 'Country' column from the beta_div_df dataframe
beta_div_df_numeric <- beta_div_df[, -1]
beta_div_matrix <- as.matrix(beta_div_df_numeric)

# Calculate Bray-Curtis dissimilarity matrix, with rarefaction (to account for uneven sampling effort)
set.seed(19960606) #arbitrarily chosen number
bc_dist <- avgdist(beta_div_matrix, dmethod = "bray", sample=27)
set.seed(19960606)
bc_nmds <- metaMDS(bc_dist)
###########################.

########################### PCoA of GCF presence/absence (jaccard) for each COUNTRY ###########################
# Use gcf_diversity dataframe from earlier

# Group by Country (status and continent) and summarize all columns (merge GCF pres/abs for each COUNTRY)
gcf_country_div <- gcf_diversity %>%
  group_by(Country,Status, Continent) %>%
  summarise_all(.funs = function(x) if_else(any(x == 1), 1, 0)) %>%
  select(-Genome.ID)%>%
  filter(Country != "")

# Remove metadata columns (Status and Country and Continent) from gcf_diversity_merged
gcf_country_matrix <- gcf_country_div[, !(names(gcf_country_div) %in% c("Status", "Country", "Continent"))]


#run PCoA with Jaccard index
diss_country_matrix <- vegdist(gcf_country_matrix, method = "jaccard")
pcoa_country_results <- cmdscale(diss_country_matrix, eig = TRUE, k = 2)
pcoa_country_df <- as.data.frame(pcoa_country_results$points)
pcoa_country_df$Status <- gcf_country_div$Status
pcoa_country_df$Country <- gcf_country_div$Country
pcoa_country_df$Continent <- gcf_country_div$Continent

# Plot the ggplot object 
ggplot(data = pcoa_country_df, aes(x = V1, y = V2, color = Country, shape = Status)) +
  geom_point(size = 3) +  # Increase point size
  theme_minimal() +  # Minimal theme without background lines
  labs(x = "PCoA1", y = "PCoA2", color = "Country", shape = "Status") +  # Customize axis labels and legends
  theme(text = element_text(size = 15))  # Increase font size

# Too few points (because its just one per country) to calculate ellipses for all but Native vs Introduced

# Plot the ggplot object with ellipses using stat_ellipse
ggplot(data = pcoa_country_df, aes(x = V1, y = V2, color = Status)) +
  geom_point(size = 3) +  # Increase point size
  stat_ellipse(level = 0.95, geom = "polygon", aes(fill = Status), alpha = 0.2) +  # Add ellipses with 95% confidence level
  theme_minimal() +  # Minimal theme without background lines
  labs(x = "PCoA1", y = "PCoA2", color = "Status") +  # Customize axis labels and legends
  theme(text = element_text(size = 15))  # Increase font size

# Plot the ggplot object with ellipses using stat_ellipse
ggplot(data = pcoa_country_df, aes(x = V1, y = V2, color = Status, shape = Continent)) +
  geom_point(size = 3) +  # Increase point size
  stat_ellipse(level = 0.95, geom = "polygon", aes(fill = Continent), alpha = 0.1) +  # Add ellipses with 95% confidence level
  theme_minimal() +  # Minimal theme without background lines
  labs(x = "PCoA1", y = "PCoA2", color = "Status", shape = "Continent") +  # Customize axis labels and legends
  theme(text = element_text(size = 15))  # Increase font size


###########################.
########################### "Clan"significance of Status on Degree ###########################
###### Preparing the df with clan information 
  #clans <- "D:/PhD_ch1_stuff/new_assemblies/R_analysis_things/bgc_clans"
  #::dir_ls(clans)
  #clans_csv_files <- fs::dir_ls(clans, regexp = "\\.csv$")
  #readr::read_csv(clans_csv_files[24])
  # Add a new column called "clan" with all values set to ""
  #clan24$clan <- "terpeneL"
  # List of dataframes
  #clan_list <- list(clan1, clan2, clan3, clan4,clan5, clan6, clan7, clan8, clan9, clan10, clan11, clan12, clan13, clan14, clan15, clan16,
                    #clan17, clan18,clan19, clan20, clan21, clan22, clan23, clan24)
  # Combine dataframes into one large dataframe
  #clans_combined <- bind_rows(clan_list)
  # Save combined dataframe as CSV 
  #write.csv(clans_combined, file = "D:/PhD_ch1_stuff/new_assemblies/R_analysis_things/clans_combined.csv", row.names = FALSE)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#final clan df (only includes "clans" that are >100 BGCs) 
clans_combined <- read.csv("D:/PhD_ch1_stuff/new_assemblies/R_analysis_things/clans_combined.csv")
# Filter out rows with missing values in the "Status" column (the MiBig BGCs) for when they cause problems
clans_combined_filtered <- clans_combined %>%
  filter(!is.na(Status))

# Plot the Kernel Density Estimation (KDE) comparison of Degree by Clan and Status
ggplot(clans_combined_filtered, aes(x = Degree, fill = Status)) +
  # Add a density plot for each group
  geom_density(alpha = 0.5) +
  # Facet by the "clan" column to create separate panels for each group
  facet_wrap(~ clan, ncol = 4, scales="free_y") +
  # Add labels and title
  labs(x = "Degree", y = "Density", title = "Kernel Density Comparison of Degree by Clan and Status") +
  # Customize the fill colors
  scale_fill_manual(values = c("Native" = "blue", "Introduced" = "red")) +
  # Add a legend
  guides(fill = guide_legend(title = "Status"))

#### T-tests: The effect of Status (Native and Introduce) on Degree for each of the 24 clans that were >100 BGCs
# Split the clans up
clan_groups <- split(clans_combined, clans_combined$clan)
# Define a function to perform Mann-Whitney U test and tidy the results
perform_mann_whitney_test <- function(df) {
  # Perform Mann-Whitney U test
  test_result <- wilcox.test(Degree ~ Status, data = df)
  # Tidy the test result
  tidied_result <- tidy(test_result)
  # Add the clan information
  tidied_result$clan <- unique(df$clan)
  return(tidied_result)
}
# Apply the function to each group and combine the results
t_test_results <- lapply(clan_groups, perform_mann_whitney_test)
ttest_combined_results <- do.call(rbind, t_test_results)
# Six clans shows significant difference between native and introduced for Degree (p<0.05) and one more was close
significant_status_clans <- ttest_combined_results%>%
  filter(p.value <0.05)

### Randomly sample from high, medium, and low degrees within each significant (statusxdegree) clan
# Loop through and pull the data frames out of the list from earlier, name them with the same names we used in the list
for (clan_value in unique(significant_status_clans$clan)) {
  # Extract the data frame corresponding to the current 'clan' value
  selected_df <- clan_groups[[clan_value]]
  
  # Convert the selected data frame into a true data frame object
  selected_df <- as.data.frame(selected_df)
  
  # Name the extracted data frame based on the 'clan' value
  assign(paste0("df_", clan_value), selected_df)
}


#Look at the distribution of degree for each clan (to help pick the high,med, and low groups)
#note: they have very different distributions of degree
hist(df_pks1A$Degree)
hist(df_terpeneD$Degree)
hist(df_terpeneE$Degree)
hist(df_terpeneF$Degree)
hist(df_terpeneH$Degree)
hist(df_terpeneK$Degree)
#Add the break point labels to the data frames
df_pks1A<-df_pks1A%>%
  mutate(degree_category = cut(Degree,
                               breaks=c(0, 58, 110, Inf),
                               labels=c("low","medium","high"),
                               include.lowest=TRUE))
df_terpeneD<-df_terpeneD%>%
  mutate(degree_category = cut(Degree,
                               breaks=c(0, 77, 153, Inf),
                               labels=c("low","medium","high"),
                               include.lowest=TRUE))
df_terpeneE<-df_terpeneE%>%
  mutate(degree_category = cut(Degree,
                               breaks=c(0, 83, 167, Inf),
                               labels=c("low","medium","high"),
                               include.lowest=TRUE))
df_terpeneF<-df_terpeneF%>%
  mutate(degree_category = cut(Degree,
                               breaks=c(0, 77, 153, Inf),
                               labels=c("low","medium","high"),
                               include.lowest=TRUE))
df_terpeneH<-df_terpeneH%>%
  mutate(degree_category = cut(Degree,
                               breaks=c(0, 76, 152, Inf),
                               labels=c("low","medium","high"),
                               include.lowest=TRUE))
df_terpeneK<-df_terpeneK%>%
  mutate(degree_category = cut(Degree,
                               breaks=c(0, 76, 152, Inf),
                               labels=c("low","medium","high"),
                               include.lowest=TRUE))
#Plot the categories
ggplot(df_pks1A, aes(degree_category, Degree)) + 
  geom_point() +
  expand_limits(y=0)
ggplot(df_terpeneD, aes(degree_category, Degree)) + 
  geom_point() +
  expand_limits(y=0)
ggplot(df_terpeneE, aes(degree_category, Degree)) + 
  geom_point() +
  expand_limits(y=0)
ggplot(df_terpeneF, aes(degree_category, Degree)) + 
  geom_point() +
  expand_limits(y=0)
ggplot(df_terpeneH, aes(degree_category, Degree)) + 
  geom_point() +
  expand_limits(y=0)
ggplot(df_terpeneK, aes(degree_category, Degree)) + 
  geom_point() +
  expand_limits(y=0)

#Randomly sample from the categories for each clan
# Sample 5 samples from each group and bind them into a new dataframe
pks1A_clinker_samples <- df_pks1A %>%
  group_by(degree_category) %>%
  slice_sample(n = 5) %>%
  ungroup()%>%
  select(name, Degree, Country, State, clan, degree_category)
terpeneD_clinker_samples <- df_terpeneD %>%
  group_by(degree_category) %>%
  slice_sample(n = 5) %>%
  ungroup()%>%
  select(name, Degree, Country, State, clan, degree_category)
terpeneE_clinker_samples <- df_terpeneE %>%
  group_by(degree_category) %>%
  slice_sample(n = 5) %>%
  ungroup()%>%
  select(name, Degree, Country, State, clan, degree_category)
terpeneF_clinker_samples <- df_terpeneF %>%
  group_by(degree_category) %>%
  slice_sample(n = 5) %>%
  ungroup()%>%
  select(name, Degree, Country, State, clan, degree_category)
terpeneH_clinker_samples <- df_terpeneH %>%
  group_by(degree_category) %>%
  slice_sample(n = 5) %>%
  ungroup()%>%
  select(name, Degree, Country, State, clan, degree_category)
terpeneK_clinker_samples <- df_terpeneK %>%
  group_by(degree_category) %>%
  slice_sample(n = 5) %>%
  ungroup()%>%
  select(name, Degree, Country, State, clan, degree_category)
#Merge all of the clinker_sample dfs into one
clinker_samples_list <- list(pks1A_clinker_samples,terpeneD_clinker_samples, terpeneE_clinker_samples, terpeneF_clinker_samples, terpeneH_clinker_samples, terpeneK_clinker_samples)
# Merge all data frames into one
combined_clinker_samples <- bind_rows(clinker_samples_list)
# Export the combined data frame as a CSV file
#write.csv(combined_clinker_samples, "D:/PhD_ch1_stuff/new_assemblies/R_analysis_things/combined_clinker_samples.csv", row.names = FALSE)


###########################.
########################### GCF significance of Status on Degree ###########################
# Filter out rows with missing values in the "Status" column (the MiBig BGCs) for when they cause problems
GCF_filtered <- mydata %>%
  filter(!is.na(Genome.ID)) %>%
  group_by(Family.Number) %>%
  mutate(GCF_Size = n()) %>%
  filter(GCF_Size > 9 & !is.na(GCF_Size))
# Find Family.Numbers that have both "Native" and "Introduced" statuses
family_numbers_with_both <- GCF_filtered %>%
  group_by(Family.Number) %>%
  filter(all(c("Native", "Introduced") %in% Status)) %>%
  pull(Family.Number)
# Filter out rows corresponding to those Family.Numbers
GCF_filtered <- GCF_filtered %>%
  filter(Family.Number %in% family_numbers_with_both)
# Split the GCFs up
GCF_groups <- split(GCF_filtered, GCF_filtered$Family.Number)
# Remove grouping and convert to data frames
GCF_groups <- lapply(GCF_groups, function(df) as.data.frame(ungroup(df)))

# Define a function to perform Mann-Whitney U test and tidy the results (used the Approximate Wilcoxon rank sum test even though it doesn't show because there were ties causing errors)
perform_mann_whitney_test_GCF <- function(df) {
  # Ensure that there are exactly 2 unique levels in the 'Status' column
  if (length(unique(df$Status)) != 2) {
    stop("Grouping factor 'Status' must have exactly 2 levels.")
  }
  
  # Perform Mann-Whitney U test with exact = FALSE
  test_result_GCF <- wilcox.test(Degree ~ Status, data = df, exact = FALSE)
  
  # Tidy the test result
  tidied_result_GCF <- tidy(test_result_GCF)
  
  # Add the Family.Number information
  tidied_result_GCF$Family.Number <- unique(df$Family.Number)
  
  return(tidied_result_GCF)
}
# Apply the function to each group and combine the results
t_test_results_GCFs <- lapply(GCF_groups, perform_mann_whitney_test_GCF)
# Combine the results into a single dataframe
ttest_combined_results_GCF <- do.call(rbind, t_test_results_GCFs)
#1-27 (rows when sorted small to large p value) were p<0.05 (thats 27/225 GCFs that were >9 BGCs and were found in both Status groups)

#make a list of counts for each significant GCF
ttest_combined_results_GCF%>%
  arrange(p.value)
GCF_merged_df <- left_join(ttest_combined_results_GCF, GCF_counts, by = "Family.Number")
significant_status_GCFs <- GCF_merged_df %>%
  filter(p.value < 0.05)

#Histogram of GCF Size (how many BGCs/family)
# Group by Family.Number and count the number of BGCs per Family.Number
GCF_counts <- mydata %>%
  group_by(Family.Number) %>%
  summarise(GCF_Size = n()) %>%
  filter(GCF_Size > 9)
# Plot histogram
ggplot(GCF_counts, aes(x = GCF_Size)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black") +
  labs(x = "GCF Size (Number of BGCs)", y = "Frequency", title = "Histogram of GCF Size")

###########################.
########################### Mapping lat/long ###########################
lat_long_md <- read.csv("D:/PhD_ch1_stuff/new_assemblies/R_analysis_things/lat_long_metadata.csv")
lat_long <- lat_long_md%>%
  drop_na(OrganismLongitude)%>%
  drop_na(OrganismLatitude)
  
mapview(lat_long, xcol = "OrganismLongitude", ycol = "OrganismLatitude", crs = 4269, grid = FALSE)

###########################.