# symlink all of the fastq files into ~/slu_fastq
ln -s ~/slu_all_data/Suilutsequencing_*/Raw_Data/*.fastq.gz $PWD

# symlink all of the suilutsequencing fiels into ~/slu_working
ln -s ~/slu_raw_data/Suilutsequencing_*/ $PWD

# Trimmomatic for loop
for i in ~/slu_fastq/*.fastq.gz; 
do java -jar $TRIMMOMATIC SE -threads 4 \
    $i \
    ${i%}.trimmed.gz \
    ILLUMINACLIP:TruSeq3-SE.fa:2:30:10 \
    LEADING:20 TRAILING:20 SLIDINGWINDOW:4:25 MINLEN:50 \
    2>&1 | tee trimmomatic.log; 
done
# Some explanation of the trimmomatic specifics
* guessed on the adapters based on the use of HiSeq 2500. Trimmomatic documentation says "TruSeq3 (as used by HiSeq and MiSeq machines), for both single-end and paired-end mode" so i selected the TruSeq3-SE.fa.
* had to add a "TrueSeq-3.fa" file into the working directory which contains these two sequences (I am not sure what each one does, or if both are needed)
`>TruSeq3_IndexedAdapter AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC`
`>TruSeq3_UniversalAdapter AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA` 
* ILLUMINACLIP:TruSeq3_SE.fa:2:30:10
    Remove Illumina adapters provided in the TruSeq3-PE.fa file (provided).  Initially Trimmomatic will look for seed matches (16 bases) allowing maximally 2 mismatches. These seeds will be extended and clipped if in the case of paired end reads a score of 30 is reached (about 50 bases), or in the case of single ended reads a score of 10, (about 17 bases). The :30: parameter has no effect, but a value has to be specified nevertheless.

# FastQC
## first, make an output directory (eg. fastqcOut), then:
`module load fastqc-0.11.7`
`fastqc *_trimmed.fastq.gz -o ./fastqcOut/`

# Steps of assembly
* Deinterleave (done)
* Trimm (done)
* fastqc
* spades
* fastqc
* Spades
* quast
* busco
* Repeatmasker