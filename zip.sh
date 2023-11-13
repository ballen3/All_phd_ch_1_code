#!/bin/bash
#PBS -N zip
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -M ballen3@go.olemiss.edu

gzip ~/slu_raw/deinterleaved_slu/*.fastq