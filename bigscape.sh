#!/bin/bash
#PBS -N antismash
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=50gb
#PBS -m abe
#PBS -M ballen3@go.olemiss.edu

source activate bigscape

module load bigscape 

#Run the following command to perform a BigScape analysis on your fungal genomes:
bigscape.py -i /path/to/antismash/output/region_table.csv -c /path/to/antismash/output/final_clusters.txt -t fungi -o /path/to/bigscape/output/ --pfam --mibig --cutoffs 0.3,0.5,0.7,0.9

# FLAGS
#--pfam option tells BigSCAPE to use Pfam domains for domain similarity calculations.
#--mibig option tells BigSCAPE to use the MiBIG database for reference clustering.
#--cutoffs option specifies the clustering thresholds to use. In this example, the thresholds are set at 0.3, 0.5, 0.7, and 0.9.

# OUTPUT FILES
#The output files will be saved in a directory called "output" in the same directory as the input files. 
#network.gexf: A network file in GEXF format that can be visualized with a network visualization tool like Cytoscape. The nodes in the network represent clusters, and the edges represent similarity between the clusters.
#all_clusters.faa: A FASTA file containing the amino acid sequences of all the clusters in the input dataset.
#clustering_c0.3.tsv, clustering_c0.5.tsv, clustering_c0.7.tsv, and clustering_c0.9.tsv: Tab-separated files containing the clustering results for the specified cutoff values.
#clustering_summary.tsv: A summary file containing statistics about the clustering results.
#pangenome_matrix.tsv: A tab-separated file containing a matrix of similarity scores between all pairs of clusters in the input dataset.
#alignment_scores.tsv: A tab-separated file containing the similarity scores between pairs of clusters based on sequence alignment.
#gene_count_matrix.tsv: A tab-separated file containing a matrix of the number of genes shared between all pairs of clusters in the input dataset.
#pfam_hits.tsv: A tab-separated file containing information about the Pfam domains present in each cluster.
#log.txt: A log file containing information about the analysis, including the settings used, the progress of the analysis, and any error messages that occurred.