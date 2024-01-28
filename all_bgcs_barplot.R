# install.packages("ggplot2")
library(ggplot2)

setwd("D:/PhD_ch1_stuff/bigscape_output_all/network_files/2023-11-26_04-35-16_hybrids_glocal/")
mydata<-read.table(file = 'D:/PhD_ch1_stuff/bigscape_output_all/network_files/2023-11-26_04-35-16_hybrids_glocal/Network_Annotations_Full_edited - Network_Annotations_Full.tsv.tsv', sep = '\t', header = TRUE)
View(mydata)

# install.packages("dplyr")
# install.packages("scales")
library(dplyr)

# Data transformation (getting the count and percentages of the BGC classes)
df <- mydata %>% 
  group_by(BiG.SCAPE.class) %>% # Variable to be transformed
  count() %>% 
  ungroup() %>% 
  mutate(perc = `n` / sum(`n`)) %>% 
  arrange(perc) %>%
  mutate(labels = scales::percent(perc))
View(df)

# Barplot Inside bars
p<-ggplot(df, aes(x=BiG.SCAPE.class, y=n, fill=BiG.SCAPE.class)) +
  geom_bar(stat="identity")+ theme_minimal() +
  geom_text(aes(label=labels), vjust=1.1, color="white", size=4)+
  labs(y= "Number of Clusters", x = "BGC Classes")
# Barplot Themeing
mynamestheme <- theme(
  plot.title = element_blank(),
  legend.title = element_blank(),
  legend.text = element_blank(),
  axis.title = element_text(family = "Helvetica", size = (15), colour = "steelblue4"),
  axis.text = element_text(family = "Helvetica", colour = "steelblue4", size = (12))
)
print(p + mynamestheme + theme(legend.position = "none"))


####NATIVE VS INTRODUCED####
# Calculate total counts for each BiG.SCAPE.class within each Status
class_status_counts <- mydata %>%
  group_by(BiG.SCAPE.class, Status) %>%
  summarize(class_status_count = n())
# Calculate total counts for each Status
status_total_counts <- mydata %>%
  group_by(Status) %>%
  summarize(total_count = n())
# Merge the data frames to get the total count for each Status in the class_status_counts
class_status_counts <- merge(class_status_counts, status_total_counts, by = "Status")
# Calculate the normalized proportion for each BiG.SCAPE.class within each Status
class_status_counts <- class_status_counts %>%
  mutate(normalized_proportion = class_status_count / total_count)
# View the result
View(class_status_counts)

d<-ggplot(class_status_counts, aes(x = BiG.SCAPE.class, y = normalized_proportion, fill = Status)) + 
  geom_bar(stat = "identity") +
  labs(y= "Normalized Proportion of Clusters", x = "BGC Classes") +
  theme (axis.text = element_text(family = "Helvetica", colour = "steelblue4", size = (12)),
         axis.title = element_text(family = "Helvetica", size = (15), colour = "steelblue4"),
         legend.title = element_text(family = "Helvetica", size = (15), colour = "steelblue4"),
         legend.text = element_text(family = "Helvetica", size = (15), colour = "steelblue4"))
d 

