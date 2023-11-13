import os
import glob

# Directory path containing Quast output directories with _output suffix
quast_output_directory = os.path.expanduser('~/slu_fresh/quast_reports')

# Output file to save the summary
output_file = 'L50_summary.csv'

# Initialize a list to store L50 information and skipped files
L50_info = []
skipped_files = []

# Use glob with recursive=True to search for *_report.txt files in subdirectories
report_files = glob.glob(os.path.join(quast_output_directory, '**/*_report.txt'), recursive=True)

# Loop through each report file
for report_file in report_files:
    # Extract the identifier from the file path
    identifier = os.path.basename(report_file).split('_')[0]

    with open(report_file, 'r') as file:
        lines = file.readlines()
        found_L50 = False  # Initialize a flag to track if L50 information was found
        for line in lines:
            if line.startswith('L50'):
                parts = line.strip().split()
                L50_value = int(parts[1]) # takes the L50 from the "*spades_scaffolds" column instead of the "spades_scaffolds_broken" column
                L50_info.append(f"{identifier},{L50_value}")
                found_L50 = True
        if not found_L50:
            skipped_files.append(report_file)  # Add the skipped file to the list

# Write the summary to the output file
with open(output_file, 'w') as out_file:
    out_file.write("ID,L50\n")
    for info in L50_info:
        out_file.write(f"{info}\n")

# Print the L50 summary to the terminal
for info in L50_info:
    print(info)

# Print skipped files
if skipped_files:
    print("\nSkipped files (no L50 information found):")
    for skipped_file in skipped_files:
        print(skipped_file)

print(f"\nSummary saved to {output_file}")


