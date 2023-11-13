import os
import glob

# Directory where the files are located
directory = os.path.expanduser('~/slu_fresh/basic_stats/busco/BUSCO_summaries_renamed')

# Use glob to search for files matching the pattern recursively
pattern = os.path.join(directory, '**/short_summary.specific.boletales_odb10.*.busco.txt')
report_files = glob.glob(pattern, recursive=True)

# Iterate through the report files
for old_path in report_files:
    # Extract the filename from the path
    filename = os.path.basename(old_path)
    
    parts = filename.split('.')
    if len(parts) == 5:
        new_filename = f"{parts[4]}.busco.txt"
        new_path = os.path.join(directory, new_filename)
        os.rename(old_path, new_path)
        print(f"Renamed: {filename} -> {new_filename}")



import os

# Directory where the files are located
directory = os.path.expanduser('~/slu_fresh/basic_stats/busco/BUSCO_summaries_renamed/')

# Iterate through the files in the directory
for filename in os.listdir(directory):
    if filename.startswith("short_summary.specific.boletales_odb10."):
        parts = filename.split('.')
        if len(parts) == 5:
            new_filename = f"{parts[4]}.busco.txt"
            old_path = os.path.join(directory, filename)
            new_path = os.path.join(directory, new_filename)
            os.rename(old_path, new_path)
            print(f"Renamed: {filename} -> {new_filename}")



