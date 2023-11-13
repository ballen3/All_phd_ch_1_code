#!/bin/bash
#PBS -N deinterleave
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=50gb
#PBS -m abe
#PBS -M ballen3@go.olemiss.edu

# changes the current directory to the directory from which the job was submitted.
cd ${PBS_O_WORKDIR}

source activate seqfu # have to have this to make the seqfu command work (activates the conda env seqfu from within this script)
shopt -s globstar #globstar will let us match files recursively

# Checking to see if there are duplicated read ids to verify if the files were interleaved paired end reads
## grep @700605F:407:CC34RANXX:2:2201:1238:2227 0_FD_12198.2.244246.TGTGCGT-AACGCAC.fastq | head -100000  | sort | uniq -c | sort -rgk 1,1 | head
# I am pretty sure this means that it is interleaved, paired end data:
## 1 @700605F:407:CC34RANXX:2:2201:1238:2227 2:N:0:TGTGCGT+AACGCAC
## 1 @700605F:407:CC34RANXX:2:2201:1238:2227 1:N:0:TGTGCGT+AACGCAC

#you have to have seqfu, which I installed with conda in a conda env named seqfu
#this will deinterleave the ./*_FD/Raw_Data/*.fastq.gz files in a loop, naming each $base_R1.fastq.gz or $base_R2.fastq.gz and then moving all of them into a directory named deinterleaved_slu
for filename in ~/slu_raw/*_FD/Raw_Data/*.fastq.gz; do
    base=$(basename "$filename" .fastq.gz) # grabs the name of the file only from ~/slu_working/*_FD/Raw_Data/*.fastq.gz path then removes the file extension (bc we add a new on in the next step)
    seqfu dei -f _R1.fastq.gz -r _R2.fastq.gz -o "$base" "$filename";
    mv *_R1.fastq.gz ./deinterleaved_slu;
    mv *_R2.fastq.gz ./deinterleaved_slu;
    rm "$filename" #removes the original combined files (i am space limited) be careful with this
done

# WARNING!!!!: This did not actually gzip the files, it only added the .gz ending!
# I had to go back through and remove the fake .gz and then actually gzip the deinterleaved files
