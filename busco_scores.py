import os
import csv
import re

### Will sort all of the busco completeness scores for all of the files in the given dir into a .csv file along with the ID of the file
### Eg) ID,Score
###     10.busco,43.6
###     42.busco,94.2
###     115.busco,59.2

# Specify the directory where your files are located
directory = "~/slu_fresh/basic_stats/busco/BUSCO_summaries"

# Create a CSV file to store the results
with open("busco_scores.csv", "w", newline="") as csv_file:
    csv_writer = csv.writer(csv_file)
    csv_writer.writerow(["ID", "Score"])

# Expand the user directory
directory = os.path.expanduser(directory)

# Loop through files in the specified directory
for filename in os.listdir(directory):
    if filename.endswith(".txt"):
        file_path = os.path.join(directory, filename)
        score = None

        # Open each file
        with open(file_path, "r") as file:
            # Read lines and look for lines with "C:" regardless of leading spaces
            for line in file:
                match = re.search(r'\s*C:(\d+\.\d)%', line)
                if match:
                    score = match.group(1)
                    break  # Stop looking after the first match

        # If a matching line was found, write it to the CSV
        if score:
            with open("busco_scores.csv", "a", newline="") as csv_file:
                csv_writer = csv.writer(csv_file)
                csv_writer.writerow([os.path.splitext(filename)[0], score])

########################################################################################

import csv
### create a separate CSV file with only the score values greater than 90 (pulling from the .csv created above/before of all busco completeness scores)

# Read the original CSV file and create a list of rows with scores > 90
high_scores = []
with open("busco_scores.csv", "r") as csv_file:
    csv_reader = csv.reader(csv_file)
    next(csv_reader)  # Skip the header row
    for row in csv_reader:
        id, score = row
        if float(score) > 90:
            high_scores.append([id, score])

# Write the high scores to a new CSV file
with open("high_scores.csv", "w", newline="") as csv_file:
    csv_writer = csv.writer(csv_file)
    csv_writer.writerow(["ID", "Score"])
    csv_writer.writerows(high_scores)
