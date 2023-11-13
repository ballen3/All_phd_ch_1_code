#!/bin/bash
#PBS -N trim
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -M ballen3@go.olemiss.edu

module load trimmomatic

# changes the current directory to the directory from which the job was submitted.
cd "${PBS_O_WORKDIR} || exit" || exit

# Trimmomatic for loop
#WORKING AS OF 4/27/23
TRIMMOMATIC=~/practice_code/Trimmomatic-0.39/trimmomatic-0.39.jar #location of the trimmomatic jar file
for f1 in *1.fastq.gz
do
    f2=${f1%%1.fastq.gz}"2.fastq.gz"
    java -jar "$TRIMMOMATIC" PE -phred33 -threads 4 \
    "$f1" "$f2" \
    "${f1%.fastq.gz}""_P.trimmed.fastq.gz" "${f1%.fastq.gz}""_U.trimmed.fastq.gz" \
    "${f2%.fastq.gz}""_P.trimmed.fastq.gz" "${f2%.fastq.gz}""_U.trimmed.fastq.gz" \
    ILLUMINACLIP:./TruSeq3-PE-2.fa:2:30:10 \
    LEADING:20 TRAILING:20 SLIDINGWINDOW:4:25 MINLEN:50 \
    2>&1 | tee trimmomatic.log;
    rm "$f1" #removes the original files after trimming to save on space
    rm "$f2"
done #make sure the TruSeq3-PE-2.fa file is in the directory you're running this from (./)

# trimming removes adapters from the raw reads and is the first step in my assembly pipeline (before fastqc and spades)

# Some explanation of the trimmomatic specifics
# guessed on the adapters based on the use of HiSeq 2500 (but some data is Novaseq). Trimmomatic documentation says "TruSeq3 (as used by HiSeq and MiSeq machines), for both single-end and paired-end mode"
# ILLUMINACLIP:TruSeq3_PE-2.fa:2:30:10 (the data is PE even though it's all in one file: it had to be deinterleaved to R1 and R2)
# Remove Illumina adapters provided in the TruSeq3-PE-2.fa file (provided). Initially Trimmomatic will look for seed matches (16 bases) allowing maximally 2 mismatches.
# These seeds will be extended and clipped if in the case of paired end reads a score of 30 is reached (about 50 bases), or in the case of single ended reads a score of 10, (about 17 bases).
# The :30: parameter is the palindromeClipThreshold, which specifies how accurate the match between the two 'adapter ligated' reads must be for PE palindrome read alignment.


# WARNING NOTE ABOUT NAMING: SPADES does not like the ".trimmed.gz" ending bc it wants "fastq.gz" so in the future make the file ending read as ".trimmed.fastq.gz" to avoid using the rename.sh script (fixed in this version now)
# You have to add the ".gz" ending so that it will make the output zipped. Which you def want or you will run out of space.

#Note on output files
#In Trimmomatic output, the "paired" (P) files contain reads that have passed the filtering criteria and still occur in pairs, i.e., the forward (R1) and reverse (R2) reads in a pair have both survived the filtering process. 
#On the other hand, the "unpaired" (U) files contain reads that either did not pass the filtering criteria or whose pair did not survive the filtering process, resulting in unpaired reads.
#Paired-end sequencing generates two reads for each DNA fragment, one forward and one reverse, and these reads are expected to overlap. 
#The paired reads are expected to have similar lengths and to overlap partially or completely. 
#In Trimmomatic, both forward and reverse reads are trimmed together, and if one of the reads fails the filtering criteria or does not overlap with its paired read, it is written to the unpaired output file.



