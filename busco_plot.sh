# generate an R plot of the busco scores for each of the assembled genomes.
# --no_r is to not run R
# if you want to use it with R on the HPC you need to module load R first, then it will make a .png for you on the HPC than you can then move to local computer.
# -wd is the working directory where your busco summaries are found
python3 /usr/local/apps/anaconda3-202210/envs/busco-5.5.0/bin/generate_plot.py --no_r -wd ~/slu_raw/deinterleaved_slu/busco_output/BUSCO_summaries