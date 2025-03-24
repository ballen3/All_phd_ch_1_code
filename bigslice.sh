#!/bin/bash
#PBS -N bigslice
#PBS -j oe
#PBS -l ncpus=10
#PBS -l mem=35gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

#changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit

bigslice -i ~/slu_fresh/bigslice/input_dir ~/slu_fresh/bigslice/output 





#!/bin/bash
#PBS -N bigslice_metadata
#PBS -j oe
#PBS -l ncpus=10
#PBS -l mem=35gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu

# Define the input directory and the output file
input_dir=~/slu_fresh/bigslice/input_dir
output_file=~/slu_fresh/bigslice/datasets.tsv

# Print the header to the output file
echo -e "# Dataset name\tPath to folder\tPath to taxonomy\tDescription" > "$output_file"

# Iterate over each directory in the input directory
for dir in "$input_dir"/*/; do
    # Get the base name of the directory (e.g., dataset_1)
    dataset_name=$(basename "$dir")
    
    # Define the path to folder, path to taxonomy, and description
    path_to_folder="${dataset_name}/"
    path_to_taxonomy="taxonomy/${dataset_name}_taxonomy.tsv"
    description="${dataset_name}"
    
    # Append the dataset information to the output file
    echo -e "${dataset_name}\t${path_to_folder}\t${path_to_taxonomy}\t${description}" >> "$output_file"
done


#!/bin/bash
#PBS -N bigslice_taxonomy
#PBS -j oe
#PBS -l ncpus=10
#PBS -l mem=35gb
#PBS -m abe
#PBS -l walltime=800:00:00
#PBS -M ballen3@go.olemiss.edu
# Define the input directory and the taxonomy directory
input_dir=~/slu_fresh/bigslice/input_dir
taxonomy_dir=~/slu_fresh/bigslice/taxonomy

# Create the taxonomy directory if it doesn't exist
mkdir -p "$taxonomy_dir"

# Iterate over each directory in the input directory
for dir in "$input_dir"/*/; do
    # Get the base name of the directory (e.g., dataset_1)
    dataset_name=$(basename "$dir")
    
    # Define the path to the taxonomy file
    taxonomy_file="${taxonomy_dir}/${dataset_name}_taxonomy.tsv"
    
    # Write the header and data to the taxonomy file
    {
        echo -e "# Genome folder\tKingdom\tPhylum\tClass\tOrder\tFamily\tGenus\tSpecies\tOrganism"
        echo -e "${dataset_name}/\tFungi\tBasidiomycota\tAgaricomycetes\tBoletales\tSuillaceae\tSuillus\tluteus\tN/A"
    } > "$taxonomy_file"
done