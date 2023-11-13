#!/bin/bash
#PBS -N rename
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -M ballen3@go.olemiss.edu

#This file contains multiple renaming scripts!

for file in ~/*.fastq.gz.trimmed.gz
do
    mv "$file" "${file%.fastq.gz.trimmed.gz}.trimmed.fastq.gz"
done
# had to do this because spades didn't recognize ".trimmed.gz" even though it's just the trimmed fastq. So had to swap the word trimmed around



# changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR}" || exit
# seeing about renaming all of the files to their more simple numerical names
for var in ~/Suilutsequencing_*/
do
    new=${var%/Raw_Data/*}
    mv "$var" "${new%/Raw_Data}"
done




#!/bin/bash
#works: renames /Suilutsequencing_**/ directory to just the **
shopt -s globstar  ##globstar will let us match files recursively
files=( ./Suilutsequencing_* )  ##Array containing matched files, mention where to search and what files here (starting in the slu_all_data file)
for i in ${files[@]}; do
    mv $i "${i#*Suilutsequencing_}"  # removes Suilutsequencing_ from Suilutsequencing_**
done



#!/bin/bash
# Working!: adds *_FD to the front of all of the *.fastq.gz files in everty ~/slu_working/*_FD/Raw_Data/
# Loop through each file in the directory with the .fastq.gz extension
for filename in ~/slu_raw/*_FD/Raw_Data/*.fastq.gz; do
    # Check if the file exists and is a regular file
    if [ -f "$filename" ]; then
        # Get the grandparent directory name
        parentdir=$(basename "$(dirname "$(dirname "$filename")")")
        # Get the original filename without the extension
        basename=$(basename "$filename")
        # Rename the file with the grandparent directory name and the original extension
        newname="$parentdir"_"$basename"
        mv "$filename" "$(dirname "$filename")/$newname"
        echo "Renamed $filename to $(dirname "$filename")/$newname"
    fi
done


# Remove a mistake "9_FD_" from the front of all of the files in the path *_FD/Raw_Data/9_FD_*.fastq.gz
for file in *_FD/Raw_Data/9_FD_*.fastq.gz
do
    filename=$(basename "$file")
    newname=${filename/9_FD_/}
    if [ "$filename" != "$newname" ]
    then
        mv "$file" "${file%/*}/$newname"
        echo "Renamed $filename to $newname"
    fi
done

