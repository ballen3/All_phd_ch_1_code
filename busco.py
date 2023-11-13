import os

file_names=[
    "0_spades_scaffolds.fasta.gz",
    "100_spades_scaffolds.fasta.gz",
    "101_spades_scaffolds.fasta.gz",
    "102_spades_scaffolds.fasta.gz",
    "103_spades_scaffolds.fasta.gz",
    "105_spades_scaffolds.fasta.gz",
    "106_spades_scaffolds.fasta.gz",
    "109_spades_scaffolds.fasta.gz",
    "10_spades_scaffolds.fasta.gz",
    "110_spades_scaffolds.fasta.gz",
    "111_spades_scaffolds.fasta.gz",
    "114_spades_scaffolds.fasta.gz",
    "115_spades_scaffolds.fasta.gz",
    "116_spades_scaffolds.fasta.gz",
    "117_spades_scaffolds.fasta.gz",
    "118_spades_scaffolds.fasta.gz",
    "119_spades_scaffolds.fasta.gz",
    "11_spades_scaffolds.fasta.gz",
    "120_spades_scaffolds.fasta.gz",
    "121_spades_scaffolds.fasta.gz",
    "122_spades_scaffolds.fasta.gz",
    "123_spades_scaffolds.fasta.gz",
    "124_spades_scaffolds.fasta.gz",
    "125_spades_scaffolds.fasta.gz",
    "126_spades_scaffolds.fasta.gz",
    "127_spades_scaffolds.fasta.gz",
    "128_spades_scaffolds.fasta.gz",
    "129_spades_scaffolds.fasta.gz",
    "12_spades_scaffolds.fasta.gz",
    "130_spades_scaffolds.fasta.gz",
    "131_spades_scaffolds.fasta.gz",
    "132_spades_scaffolds.fasta.gz",
    "133_spades_scaffolds.fasta.gz",
    "134_spades_scaffolds.fasta.gz",
    "135_spades_scaffolds.fasta.gz",
    "136_spades_scaffolds.fasta.gz",
    "137_spades_scaffolds.fasta.gz",
    "138_spades_scaffolds.fasta.gz",
    "139_spades_scaffolds.fasta.gz",
    "13_spades_scaffolds.fasta.gz",
    "140_spades_scaffolds.fasta.gz",
    "141_spades_scaffolds.fasta.gz",
    "142_spades_scaffolds.fasta.gz",
    "143_spades_scaffolds.fasta.gz",
    "144_spades_scaffolds.fasta.gz",
    "146_spades_scaffolds.fasta.gz",
    "147_spades_scaffolds.fasta.gz",
    "148_spades_scaffolds.fasta.gz",
    "149_spades_scaffolds.fasta.gz",
    "14_spades_scaffolds.fasta.gz",
    "150_spades_scaffolds.fasta.gz",
    "151_spades_scaffolds.fasta.gz",
    "152_spades_scaffolds.fasta.gz",
    "153_spades_scaffolds.fasta.gz",
    "154_spades_scaffolds.fasta.gz",
    "156_spades_scaffolds.fasta.gz",
    "157_spades_scaffolds.fasta.gz",
    "158_spades_scaffolds.fasta.gz",
    "159_spades_scaffolds.fasta.gz",
    "15_spades_scaffolds.fasta.gz",
    "160_spades_scaffolds.fasta.gz",
    "161_spades_scaffolds.fasta.gz",
    "162_spades_scaffolds.fasta.gz",
    "163_spades_scaffolds.fasta.gz",
    "164_spades_scaffolds.fasta.gz",
    "165_spades_scaffolds.fasta.gz",
    "166_spades_scaffolds.fasta.gz",
    "167_spades_scaffolds.fasta.gz",
    "169_spades_scaffolds.fasta.gz",
    "16_spades_scaffolds.fasta.gz",
    "170_spades_scaffolds.fasta.gz",
    "172_spades_scaffolds.fasta.gz",
    "174_spades_scaffolds.fasta.gz",
    "175_spades_scaffolds.fasta.gz",
    "176_spades_scaffolds.fasta.gz",
    "179_spades_scaffolds.fasta.gz",
    "17_spades_scaffolds.fasta.gz",
    "180_spades_scaffolds.fasta.gz",
    "181_spades_scaffolds.fasta.gz",
    "182_spades_scaffolds.fasta.gz",
    "183_spades_scaffolds.fasta.gz",
    "184_spades_scaffolds.fasta.gz",
    "185_spades_scaffolds.fasta.gz",
    "186_spades_scaffolds.fasta.gz",
    "187_spades_scaffolds.fasta.gz",
    "188_spades_scaffolds.fasta.gz",
    "189_spades_scaffolds.fasta.gz",
    "18_spades_scaffolds.fasta.gz",
    "190_spades_scaffolds.fasta.gz",
    "191_spades_scaffolds.fasta.gz",
    "192_spades_scaffolds.fasta.gz",
    "193_spades_scaffolds.fasta.gz",
    "194_spades_scaffolds.fasta.gz",
    "196_spades_scaffolds.fasta.gz",
    "197_spades_scaffolds.fasta.gz",
    "198_spades_scaffolds.fasta.gz",
    "199_spades_scaffolds.fasta.gz",
    "19_spades_scaffolds.fasta.gz",
    "201_spades_scaffolds.fasta.gz",
    "202_spades_scaffolds.fasta.gz",
    "203_spades_scaffolds.fasta.gz",
    "204_spades_scaffolds.fasta.gz",
    "205_spades_scaffolds.fasta.gz",
    "206_spades_scaffolds.fasta.gz",
    "207_spades_scaffolds.fasta.gz",
    "209_spades_scaffolds.fasta.gz",
    "20_spades_scaffolds.fasta.gz",
    "210_spades_scaffolds.fasta.gz",
    "213_spades_scaffolds.fasta.gz",
    "215_spades_scaffolds.fasta.gz",
    "216_spades_scaffolds.fasta.gz",
    "217_spades_scaffolds.fasta.gz",
    "218_spades_scaffolds.fasta.gz",
    "219_spades_scaffolds.fasta.gz",
    "21_spades_scaffolds.fasta.gz",
    "220_spades_scaffolds.fasta.gz",
    "222_spades_scaffolds.fasta.gz",
    "223_spades_scaffolds.fasta.gz",
    "224_spades_scaffolds.fasta.gz",
    "225_spades_scaffolds.fasta.gz",
    "226_spades_scaffolds.fasta.gz",
    "227_spades_scaffolds.fasta.gz",
    "22_spades_scaffolds.fasta.gz",
    "230_spades_scaffolds.fasta.gz",
    "233_spades_scaffolds.fasta.gz",
    "234_spades_scaffolds.fasta.gz",
    "235_spades_scaffolds.fasta.gz",
    "236_spades_scaffolds.fasta.gz",
    "237_spades_scaffolds.fasta.gz",
    "238_spades_scaffolds.fasta.gz",
    "239_spades_scaffolds.fasta.gz",
    "23_spades_scaffolds.fasta.gz",
    "240_spades_scaffolds.fasta.gz",
    "241_spades_scaffolds.fasta.gz",
    "243_spades_scaffolds.fasta.gz",
    "245_spades_scaffolds.fasta.gz",
    "246_spades_scaffolds.fasta.gz",
    "248_spades_scaffolds.fasta.gz",
    "24_spades_scaffolds.fasta.gz",
    "250_spades_scaffolds.fasta.gz",
    "251_spades_scaffolds.fasta.gz",
    "252_spades_scaffolds.fasta.gz",
    "253_spades_scaffolds.fasta.gz",
    "254_spades_scaffolds.fasta.gz",
    "255_spades_scaffolds.fasta.gz",
    "256_spades_scaffolds.fasta.gz",
    "257_spades_scaffolds.fasta.gz",
    "258_spades_scaffolds.fasta.gz",
    "259_spades_scaffolds.fasta.gz",
    "25_spades_scaffolds.fasta.gz",
    "260_spades_scaffolds.fasta.gz",
    "262_spades_scaffolds.fasta.gz",
    "263_spades_scaffolds.fasta.gz",
    "267_spades_scaffolds.fasta.gz",
    "268_spades_scaffolds.fasta.gz",
    "269_spades_scaffolds.fasta.gz",
    "26_spades_scaffolds.fasta.gz",
    "270_spades_scaffolds.fasta.gz",
    "271_spades_scaffolds.fasta.gz",
    "272_spades_scaffolds.fasta.gz",
    "273_spades_scaffolds.fasta.gz",
    "275_spades_scaffolds.fasta.gz",
    "276_spades_scaffolds.fasta.gz",
    "278_spades_scaffolds.fasta.gz",
    "279_spades_scaffolds.fasta.gz",
    "27_spades_scaffolds.fasta.gz",
    "280_spades_scaffolds.fasta.gz",
    "281_spades_scaffolds.fasta.gz",
    "282_spades_scaffolds.fasta.gz",
    "284_spades_scaffolds.fasta.gz",
    "285_spades_scaffolds.fasta.gz",
    "286_spades_scaffolds.fasta.gz",
    "287_spades_scaffolds.fasta.gz",
    "289_spades_scaffolds.fasta.gz",
    "28_spades_scaffolds.fasta.gz",
    "291_spades_scaffolds.fasta.gz",
    "292_spades_scaffolds.fasta.gz",
    "293_spades_scaffolds.fasta.gz",
    "294_spades_scaffolds.fasta.gz",
    "295_spades_scaffolds.fasta.gz",
    "296_spades_scaffolds.fasta.gz",
    "298_spades_scaffolds.fasta.gz",
    "29_spades_scaffolds.fasta.gz",
    "2_spades_scaffolds.fasta.gz",
    "30_spades_scaffolds.fasta.gz",
    "31_spades_scaffolds.fasta.gz",
    "32_spades_scaffolds.fasta.gz",
    "33_spades_scaffolds.fasta.gz",
    "34_spades_scaffolds.fasta.gz",
    "35_spades_scaffolds.fasta.gz",
    "36_spades_scaffolds.fasta.gz",
    "37_spades_scaffolds.fasta.gz",
    "38_spades_scaffolds.fasta.gz",
    "39_spades_scaffolds.fasta.gz",
    "3_spades_scaffolds.fasta.gz",
    "40_spades_scaffolds.fasta.gz",
    "41_spades_scaffolds.fasta.gz",
    "42_spades_scaffolds.fasta.gz",
    "43_spades_scaffolds.fasta.gz",
    "44_spades_scaffolds.fasta.gz",
    "45_spades_scaffolds.fasta.gz",
    "46_spades_scaffolds.fasta.gz",
    "47_spades_scaffolds.fasta.gz",
    "49_spades_scaffolds.fasta.gz",
    "4_spades_scaffolds.fasta.gz",
    "50_spades_scaffolds.fasta.gz",
    "51_spades_scaffolds.fasta.gz",
    "52_spades_scaffolds.fasta.gz",
    "53_spades_scaffolds.fasta.gz",
    "55_spades_scaffolds.fasta.gz",
    "57_spades_scaffolds.fasta.gz",
    "5_spades_scaffolds.fasta.gz",
    "63_spades_scaffolds.fasta.gz",
    "65_spades_scaffolds.fasta.gz",
    "66_spades_scaffolds.fasta.gz",
    "67_spades_scaffolds.fasta.gz",
    "68_spades_scaffolds.fasta.gz",
    "6_spades_scaffolds.fasta.gz",
    "70_spades_scaffolds.fasta.gz",
    "71_spades_scaffolds.fasta.gz",
    "72_spades_scaffolds.fasta.gz",
    "73_spades_scaffolds.fasta.gz",
    "74_spades_scaffolds.fasta.gz",
    "75_spades_scaffolds.fasta.gz",
    "76_spades_scaffolds.fasta.gz",
    "77_spades_scaffolds.fasta.gz",
    "78_spades_scaffolds.fasta.gz",
    "79_spades_scaffolds.fasta.gz",
    "7_spades_scaffolds.fasta.gz",
    "80_spades_scaffolds.fasta.gz",
    "82_spades_scaffolds.fasta.gz",
    "83_spades_scaffolds.fasta.gz",
    "84_spades_scaffolds.fasta.gz",
    "85_spades_scaffolds.fasta.gz",
    "86_spades_scaffolds.fasta.gz",
    "87_spades_scaffolds.fasta.gz",
    "88_spades_scaffolds.fasta.gz",
    "89_spades_scaffolds.fasta.gz",
    "8_spades_scaffolds.fasta.gz",
    "90_spades_scaffolds.fasta.gz",
    "91_spades_scaffolds.fasta.gz",
    "92_spades_scaffolds.fasta.gz",
    "93_spades_scaffolds.fasta.gz",
    "94_spades_scaffolds.fasta.gz",
    "96_spades_scaffolds.fasta.gz",
    "97_spades_scaffolds.fasta.gz",
    "98_spades_scaffolds.fasta.gz",
    "99_spades_scaffolds.fasta.gz",
    "9_spades_scaffolds.fasta.gz",
]

scripts = {}

# output
output="./busco_output"

# Generate bash scripts
for file_name in file_names:
    # Extract prefix from the file name
    prefix = file_name.split("_")[0]

    # Generate script content    
    script_content = f"""#!/bin/bash
#PBS -N busco_{prefix}
#PBS -j oe
#PBS -l ncpus=1
#PBS -l mem=15gb
#PBS -m abe
#PBS -l walltime=800:00:00

#changes the current directory to the directory from which the job was submitted.
cd ~/slu_raw/deinterleaved_slu || exit

#activate the conda env with busco
source activate busco-5.5.0


# Extract the compressed file before passing it to BUSCO
gunzip -c "$HOME/slu_raw/deinterleaved_slu/scaffolds/{file_name}" > "{output}/{prefix}_scaffolds.fasta"

# Run busco
echo "Running BUSCO for {prefix}"
busco -i "{output}/{prefix}_scaffolds.fasta" -l boletales_odb10 -o "{output}/{prefix}.busco" -m genome -f --offline --download_path ~/slu_raw/deinterleaved_slu/busco_downloads/


echo "BUSCO for {prefix} done!"

# clean up the duplicated gunzipped files to save space
cd $HOME/slu_raw/deinterleaved_slu/busco_output/ || exit
rm "{prefix}_scaffolds.fasta"
"""
    # Generate script file name
    script_filename = f"busco_{prefix}.sh"

    # Write script content to the file
    with open(script_filename, "w") as f:
        f.write(script_content)

    # Add execute permission to the script
    os.chmod(script_filename, 0o755)

    # Print confirmation
    print(f"Generated bash script: {script_filename}")

### to submit the resulting scripts all at once run this 3 line loop
#for script in busco_*.sh; do
#    qsub "$script"
#done

