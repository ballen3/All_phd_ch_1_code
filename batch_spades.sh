#!/bin/bash
#PBS -N genome_assemblies
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=16gb
#PBS -m abe
#PBS -M ballen3@go.olemiss.edu

# Change to the directory where your Python script is located
cd ~/practice_code

# Run the Python script
python batching_spades.py
