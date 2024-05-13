import pandas as pd
import os
import shutil

# Read the CSV file into a DataFrame
df = pd.read_csv("/ddn/home12/r2620/slu_fresh/combined_clinker_samples.csv")

# Iterate over the rows
for index, row in df.iterrows():
    # Get the file name
    file_name = row["name"]
    
    # Construct the file path
    file_path = os.path.join('/ddn/home12/r2620/slu_fresh/new_3.11.1_antismash/new_as_output/node_files_lut', file_name + ".gbk")
    
    # Get the clan name
    clan_name = row["clan"]
    
    # Destination directory to copy the files
    destination_dir = "/ddn/home12/r2620/slu_fresh/clinker_gbks/" + clan_name
    
    # Create the destination directory if it doesn't exist
    os.makedirs(destination_dir, exist_ok=True)
    
    # Copy the file from the source directory to the destination directory
    shutil.copy(file_path, destination_dir)
