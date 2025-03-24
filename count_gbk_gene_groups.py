from Bio import SeqIO
import os
import csv

# Parse a GBK file and return a list of lists consisting of BGC ID, gene group, count, clan ID, and accession
def tally_gene_groups(gbk_file, clan_id, accession):
    gene_groups = []

    for record in SeqIO.parse(gbk_file, "genbank"):
        bgc_id = record.id
        bgc_gene_groups = {}

        for feature in record.features:
            if feature.type == "CDS":
                gene_group = feature.qualifiers.get("product", ["Unknown"])[0]
                bgc_gene_groups[gene_group] = bgc_gene_groups.get(gene_group, 0) + 1

        for gene_group, count in bgc_gene_groups.items():
            gene_groups.append([bgc_id, gene_group, count, clan_id, accession])
    
    return gene_groups

# Directory containing GBK files
gbk_directory = "/ddn/home12/r2620/slu_fresh/bgc_content"

# Output CSV file
output_csv = "gene_groups_tally_with_clan_and_accession.csv"

# Prepare the CSV file for writing
with open(output_csv, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["BGC_ID", "Gene_Group", "Count", "Clan_ID", "Accession"])

    # Iterate over clan directories
    for clan_id in os.listdir(gbk_directory):
        clan_directory = os.path.join(gbk_directory, clan_id)
        
        if os.path.isdir(clan_directory):
            # Iterate over GBK files in the clan directory
            for filename in os.listdir(clan_directory):
                if filename.endswith(".gbk"):
                    gbk_file = os.path.join(clan_directory, filename)
                    accession = os.path.splitext(filename)[0]  # Remove ".gbk" extension
                    gene_groups = tally_gene_groups(gbk_file, clan_id, accession)
                    
                    # Write gene groups to the CSV file
                    for row in gene_groups:
                        writer.writerow(row)

print(f"Gene group tallies with clan and accession information have been written to {output_csv}")


