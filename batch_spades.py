import os

file_names=[
    "169_FD_52400.3.318247.CCATACGT-ACGTATGG_R1_P.trimmed.fastq.gz",
    "169_FD_52400.3.318247.CCATACGT-ACGTATGG_R1_U.trimmed.fastq.gz",
    "169_FD_52400.3.318247.CCATACGT-ACGTATGG_R2_P.trimmed.fastq.gz",
    "169_FD_52400.3.318247.CCATACGT-ACGTATGG_R2_U.trimmed.fastq.gz",
    "170_FD_52400.3.318247.AACGGTCA-TGACCGTT_R1_P.trimmed.fastq.gz",
    "170_FD_52400.3.318247.AACGGTCA-TGACCGTT_R1_U.trimmed.fastq.gz",
    "170_FD_52400.3.318247.AACGGTCA-TGACCGTT_R2_P.trimmed.fastq.gz",
    "170_FD_52400.3.318247.AACGGTCA-TGACCGTT_R2_U.trimmed.fastq.gz",
    "175_FD_52400.3.318247.ATGGTCCA-TGGACCAT_R1_P.trimmed.fastq.gz",
    "175_FD_52400.3.318247.ATGGTCCA-TGGACCAT_R1_U.trimmed.fastq.gz",
    "175_FD_52400.3.318247.ATGGTCCA-TGGACCAT_R2_P.trimmed.fastq.gz",
    "175_FD_52400.3.318247.ATGGTCCA-TGGACCAT_R2_U.trimmed.fastq.gz",
    "176_FD_52400.3.318247.TAACCGGT-ACCGGTTA_R1_P.trimmed.fastq.gz",
    "176_FD_52400.3.318247.TAACCGGT-ACCGGTTA_R1_U.trimmed.fastq.gz",
    "176_FD_52400.3.318247.TAACCGGT-ACCGGTTA_R2_P.trimmed.fastq.gz",
    "176_FD_52400.3.318247.TAACCGGT-ACCGGTTA_R2_U.trimmed.fastq.gz",
    "178_FD_13054.4.309653.CATACCAC-GTGGTATG_R1_P.trimmed.fastq.gz",
    "178_FD_13054.4.309653.CATACCAC-GTGGTATG_R1_U.trimmed.fastq.gz",
    "178_FD_13054.4.309653.CATACCAC-GTGGTATG_R2_P.trimmed.fastq.gz",
    "178_FD_13054.4.309653.CATACCAC-GTGGTATG_R2_U.trimmed.fastq.gz",
    "186_FD_52400.3.318247.GCCATAAC-GTTATGGC_R1_P.trimmed.fastq.gz",
    "186_FD_52400.3.318247.GCCATAAC-GTTATGGC_R1_U.trimmed.fastq.gz",
    "186_FD_52400.3.318247.GCCATAAC-GTTATGGC_R2_P.trimmed.fastq.gz",
    "186_FD_52400.3.318247.GCCATAAC-GTTATGGC_R2_U.trimmed.fastq.gz",
    "188_FD_52400.3.318247.GGATACCA-TGGTATCC_R1_P.trimmed.fastq.gz",
    "188_FD_52400.3.318247.GGATACCA-TGGTATCC_R1_U.trimmed.fastq.gz",
    "188_FD_52400.3.318247.GGATACCA-TGGTATCC_R2_P.trimmed.fastq.gz",
    "188_FD_52400.3.318247.GGATACCA-TGGTATCC_R2_U.trimmed.fastq.gz",
    "189_FD_52400.3.318247.CGAACTGT-ACAGTTCG_R1_P.trimmed.fastq.gz",
    "189_FD_52400.3.318247.CGAACTGT-ACAGTTCG_R1_U.trimmed.fastq.gz",
    "189_FD_52400.3.318247.CGAACTGT-ACAGTTCG_R2_P.trimmed.fastq.gz",
    "189_FD_52400.3.318247.CGAACTGT-ACAGTTCG_R2_U.trimmed.fastq.gz",
    "190_FD_52400.3.318247.GAAGTACC-GGTACTTC_R1_P.trimmed.fastq.gz",
    "190_FD_52400.3.318247.GAAGTACC-GGTACTTC_R1_U.trimmed.fastq.gz",
    "190_FD_52400.3.318247.GAAGTACC-GGTACTTC_R2_P.trimmed.fastq.gz",
    "190_FD_52400.3.318247.GAAGTACC-GGTACTTC_R2_U.trimmed.fastq.gz",
    "192_FD_52400.3.318247.TAGTGACC-GGTCACTA_R1_P.trimmed.fastq.gz",
    "192_FD_52400.3.318247.TAGTGACC-GGTCACTA_R1_U.trimmed.fastq.gz",
    "192_FD_52400.3.318247.TAGTGACC-GGTCACTA_R2_P.trimmed.fastq.gz",
    "192_FD_52400.3.318247.TAGTGACC-GGTCACTA_R2_U.trimmed.fastq.gz",
    "193_FD_52400.3.318247.CAGAGTGT-ACACTCTG_R1_P.trimmed.fastq.gz",
    "193_FD_52400.3.318247.CAGAGTGT-ACACTCTG_R1_U.trimmed.fastq.gz",
    "193_FD_52400.3.318247.CAGAGTGT-ACACTCTG_R2_P.trimmed.fastq.gz",
    "193_FD_52400.3.318247.CAGAGTGT-ACACTCTG_R2_U.trimmed.fastq.gz",
    "194_FD_52400.3.318247.GTTCAACC-GGTTGAAC_R1_P.trimmed.fastq.gz",
    "194_FD_52400.3.318247.GTTCAACC-GGTTGAAC_R1_U.trimmed.fastq.gz",
    "194_FD_52400.3.318247.GTTCAACC-GGTTGAAC_R2_P.trimmed.fastq.gz",
    "194_FD_52400.3.318247.GTTCAACC-GGTTGAAC_R2_U.trimmed.fastq.gz",
    "195_FD_13054.4.309653.CACGTTGT-ACAACGTG_R1_P.trimmed.fastq.gz",
    "195_FD_13054.4.309653.CACGTTGT-ACAACGTG_R1_U.trimmed.fastq.gz",
    "195_FD_13054.4.309653.CACGTTGT-ACAACGTG_R2_P.trimmed.fastq.gz",
    "195_FD_13054.4.309653.CACGTTGT-ACAACGTG_R1_U.trimmed.fastq.gz",
    "196_FD_52400.3.318247.CAAGGTCT-AGACCTTG_R1_P.trimmed.fastq.gz",
    "196_FD_52400.3.318247.CAAGGTCT-AGACCTTG_R1_U.trimmed.fastq.gz",
    "196_FD_52400.3.318247.CAAGGTCT-AGACCTTG_R2_P.trimmed.fastq.gz",
    "196_FD_52400.3.318247.CAAGGTCT-AGACCTTG_R2_U.trimmed.fastq.gz",
    "202_FD_52400.3.318247.GACATTCC-GGAATGTC_R1_P.trimmed.fastq.gz",
    "202_FD_52400.3.318247.GACATTCC-GGAATGTC_R1_U.trimmed.fastq.gz",
    "202_FD_52400.3.318247.GACATTCC-GGAATGTC_R2_P.trimmed.fastq.gz",
    "202_FD_52400.3.318247.GACATTCC-GGAATGTC_R2_U.trimmed.fastq.gz",
    "205_FD_52400.3.318247.ACACCAGT-ACTGGTGT_R1_P.trimmed.fastq.gz",
    "205_FD_52400.3.318247.ACACCAGT-ACTGGTGT_R1_U.trimmed.fastq.gz",
    "205_FD_52400.3.318247.ACACCAGT-ACTGGTGT_R2_P.trimmed.fastq.gz",
    "205_FD_52400.3.318247.ACACCAGT-ACTGGTGT_R2_U.trimmed.fastq.gz",
    "207_FD_52400.3.318247.CGTTGAGT-ACTCAACG_R1_P.trimmed.fastq.gz",
    "207_FD_52400.3.318247.CGTTGAGT-ACTCAACG_R1_U.trimmed.fastq.gz",
    "207_FD_52400.3.318247.CGTTGAGT-ACTCAACG_R2_P.trimmed.fastq.gz",
    "207_FD_52400.3.318247.CGTTGAGT-ACTCAACG_R2_U.trimmed.fastq.gz",
    "213_FD_52613.1.394201.CTAGGTGA-CTAGGTGA_R1_P.trimmed.fastq.gz",
    "213_FD_52613.1.394201.CTAGGTGA-CTAGGTGA_R1_U.trimmed.fastq.gz",
    "213_FD_52613.1.394201.CTAGGTGA-CTAGGTGA_R2_P.trimmed.fastq.gz",
    "213_FD_52613.1.394201.CTAGGTGA-CTAGGTGA_R2_U.trimmed.fastq.gz",
    "216_FD_52613.1.394201.TGTAGCCA-TGTAGCCA_R1_P.trimmed.fastq.gz",
    "216_FD_52613.1.394201.TGTAGCCA-TGTAGCCA_R1_U.trimmed.fastq.gz",
    "216_FD_52613.1.394201.TGTAGCCA-TGTAGCCA_R2_P.trimmed.fastq.gz",
    "216_FD_52613.1.394201.TGTAGCCA-TGTAGCCA_R2_U.trimmed.fastq.gz",
    "217_FD_52613.1.394201.TTGGCTTG-TTGGCTTG_R1_P.trimmed.fastq.gz",
    "217_FD_52613.1.394201.TTGGCTTG-TTGGCTTG_R1_U.trimmed.fastq.gz",
    "217_FD_52613.1.394201.TTGGCTTG-TTGGCTTG_R2_P.trimmed.fastq.gz",
    "217_FD_52613.1.394201.TTGGCTTG-TTGGCTTG_R2_U.trimmed.fastq.gz",
    "218_FD_52613.1.394201.GTGGTGTT-GTGGTGTT_R1_P.trimmed.fastq.gz",
    "218_FD_52613.1.394201.GTGGTGTT-GTGGTGTT_R1_U.trimmed.fastq.gz",
    "218_FD_52613.1.394201.GTGGTGTT-GTGGTGTT_R2_P.trimmed.fastq.gz",
    "218_FD_52613.1.394201.GTGGTGTT-GTGGTGTT_R2_U.trimmed.fastq.gz",
    "220_FD_52613.1.394201.TGATCGGA-TGATCGGA_R1_P.trimmed.fastq.gz",
    "220_FD_52613.1.394201.TGATCGGA-TGATCGGA_R1_U.trimmed.fastq.gz",
    "220_FD_52613.1.394201.TGATCGGA-TGATCGGA_R2_P.trimmed.fastq.gz",
    "220_FD_52613.1.394201.TGATCGGA-TGATCGGA_R2_U.trimmed.fastq.gz",
    "222_FD_52613.1.394201.CACCTGTT-CACCTGTT_R1_P.trimmed.fastq.gz",
    "222_FD_52613.1.394201.CACCTGTT-CACCTGTT_R1_U.trimmed.fastq.gz",
    "222_FD_52613.1.394201.CACCTGTT-CACCTGTT_R2_P.trimmed.fastq.gz",
    "222_FD_52613.1.394201.CACCTGTT-CACCTGTT_R2_U.trimmed.fastq.gz",
    "223_FD_52613.1.394201.CGTCAATG-CGTCAATG_R1_P.trimmed.fastq.gz",
    "223_FD_52613.1.394201.CGTCAATG-CGTCAATG_R1_U.trimmed.fastq.gz",
    "223_FD_52613.1.394201.CGTCAATG-CGTCAATG_R2_P.trimmed.fastq.gz",
    "223_FD_52613.1.394201.CGTCAATG-CGTCAATG_R2_U.trimmed.fastq.gz",
    "225_FD_52613.1.394201.CCAGGATA-CCAGGATA_R1_P.trimmed.fastq.gz",
    "225_FD_52613.1.394201.CCAGGATA-CCAGGATA_R1_U.trimmed.fastq.gz",
    "225_FD_52613.1.394201.CCAGGATA-CCAGGATA_R2_P.trimmed.fastq.gz",
    "225_FD_52613.1.394201.CCAGGATA-CCAGGATA_R2_U.trimmed.fastq.gz",
    "226_FD_52613.1.394201.TGCTCATG-TGCTCATG_R1_P.trimmed.fastq.gz",
    "226_FD_52613.1.394201.TGCTCATG-TGCTCATG_R1_U.trimmed.fastq.gz",
    "226_FD_52613.1.394201.TGCTCATG-TGCTCATG_R2_P.trimmed.fastq.gz",
    "226_FD_52613.1.394201.TGCTCATG-TGCTCATG_R2_U.trimmed.fastq.gz",
    "227_FD_52613.1.394201.CTTGGATG-CTTGGATG_R1_P.trimmed.fastq.gz",
    "227_FD_52613.1.394201.CTTGGATG-CTTGGATG_R1_U.trimmed.fastq.gz",
    "227_FD_52613.1.394201.CTTGGATG-CTTGGATG_R2_P.trimmed.fastq.gz",
    "227_FD_52613.1.394201.CTTGGATG-CTTGGATG_R2_U.trimmed.fastq.gz",
    "230_FD_52613.1.394201.TTGCTGGA-TTGCTGGA_R1_P.trimmed.fastq.gz",
    "230_FD_52613.1.394201.TTGCTGGA-TTGCTGGA_R1_U.trimmed.fastq.gz",
    "230_FD_52613.1.394201.TTGCTGGA-TTGCTGGA_R2_P.trimmed.fastq.gz",
    "230_FD_52613.1.394201.TTGCTGGA-TTGCTGGA_R2_U.trimmed.fastq.gz",
    "235_FD_52613.1.394201.ACCTAAGG-ACCTAAGG_R1_P.trimmed.fastq.gz",
    "235_FD_52613.1.394201.ACCTAAGG-ACCTAAGG_R1_U.trimmed.fastq.gz",
    "235_FD_52613.1.394201.ACCTAAGG-ACCTAAGG_R2_P.trimmed.fastq.gz",
    "235_FD_52613.1.394201.ACCTAAGG-ACCTAAGG_R2_U.trimmed.fastq.gz",
    "236_FD_52613.1.394201.TGGCACTA-TGGCACTA_R1_P.trimmed.fastq.gz",
    "236_FD_52613.1.394201.TGGCACTA-TGGCACTA_R1_U.trimmed.fastq.gz",
    "236_FD_52613.1.394201.TGGCACTA-TGGCACTA_R2_P.trimmed.fastq.gz",
    "236_FD_52613.1.394201.TGGCACTA-TGGCACTA_R2_U.trimmed.fastq.gz",
    "238_FD_52613.1.394201.TTGGTGAG-TTGGTGAG_R1_P.trimmed.fastq.gz",
    "238_FD_52613.1.394201.TTGGTGAG-TTGGTGAG_R1_U.trimmed.fastq.gz",
    "238_FD_52613.1.394201.TTGGTGAG-TTGGTGAG_R2_P.trimmed.fastq.gz",
    "238_FD_52613.1.394201.TTGGTGAG-TTGGTGAG_R2_U.trimmed.fastq.gz",
    "240_FD_52613.1.394201.CTTAGGAC-CTTAGGAC_R1_P.trimmed.fastq.gz",
    "240_FD_52613.1.394201.CTTAGGAC-CTTAGGAC_R1_U.trimmed.fastq.gz",
    "240_FD_52613.1.394201.CTTAGGAC-CTTAGGAC_R2_P.trimmed.fastq.gz",
    "240_FD_52613.1.394201.CTTAGGAC-CTTAGGAC_R2_U.trimmed.fastq.gz",
    "241_FD_52613.1.394201.CAGGTTAG-CAGGTTAG_R1_P.trimmed.fastq.gz",
    "241_FD_52613.1.394201.CAGGTTAG-CAGGTTAG_R1_U.trimmed.fastq.gz",
    "241_FD_52613.1.394201.CAGGTTAG-CAGGTTAG_R2_P.trimmed.fastq.gz",
    "241_FD_52613.1.394201.CAGGTTAG-CAGGTTAG_R2_U.trimmed.fastq.gz",
    "243_FD_52613.1.394201.GGTTGTCA-GGTTGTCA_R1_P.trimmed.fastq.gz",
    "243_FD_52613.1.394201.GGTTGTCA-GGTTGTCA_R1_U.trimmed.fastq.gz",
    "243_FD_52613.1.394201.GGTTGTCA-GGTTGTCA_R2_P.trimmed.fastq.gz",
    "243_FD_52613.1.394201.GGTTGTCA-GGTTGTCA_R2_U.trimmed.fastq.gz",
    "245_FD_52613.1.394201.AAGACTCC-AAGACTCC_R1_P.trimmed.fastq.gz",
    "245_FD_52613.1.394201.AAGACTCC-AAGACTCC_R1_U.trimmed.fastq.gz",
    "245_FD_52613.1.394201.AAGACTCC-AAGACTCC_R2_P.trimmed.fastq.gz",
    "245_FD_52613.1.394201.AAGACTCC-AAGACTCC_R2_U.trimmed.fastq.gz",
    "246_FD_52613.1.394201.GATCGTAC-GATCGTAC_R1_P.trimmed.fastq.gz",
    "246_FD_52613.1.394201.GATCGTAC-GATCGTAC_R1_U.trimmed.fastq.gz",
    "246_FD_52613.1.394201.GATCGTAC-GATCGTAC_R2_P.trimmed.fastq.gz",
    "246_FD_52613.1.394201.GATCGTAC-GATCGTAC_R2_U.trimmed.fastq.gz",
    "248_FD_52613.1.394201.CGTATTCG-CGTATTCG_R1_P.trimmed.fastq.gz",
    "248_FD_52613.1.394201.CGTATTCG-CGTATTCG_R1_U.trimmed.fastq.gz",
    "248_FD_52613.1.394201.CGTATTCG-CGTATTCG_R2_P.trimmed.fastq.gz",
    "248_FD_52613.1.394201.CGTATTCG-CGTATTCG_R2_U.trimmed.fastq.gz",
    "250_FD_52613.1.394201.GTGGATAG-GTGGATAG_R1_P.trimmed.fastq.gz",
    "250_FD_52613.1.394201.GTGGATAG-GTGGATAG_R1_U.trimmed.fastq.gz",
    "250_FD_52613.1.394201.GTGGATAG-GTGGATAG_R2_P.trimmed.fastq.gz",
    "250_FD_52613.1.394201.GTGGATAG-GTGGATAG_R2_U.trimmed.fastq.gz",
    "251_FD_52613.1.394201.GCCACTTA-GCCACTTA_R1_P.trimmed.fastq.gz",
    "251_FD_52613.1.394201.GCCACTTA-GCCACTTA_R1_U.trimmed.fastq.gz",
    "251_FD_52613.1.394201.GCCACTTA-GCCACTTA_R2_P.trimmed.fastq.gz",
    "251_FD_52613.1.394201.GCCACTTA-GCCACTTA_R2_U.trimmed.fastq.gz",
    "252_FD_52613.1.394201.TGAGGTGT-TGAGGTGT_R1_P.trimmed.fastq.gz",
    "252_FD_52613.1.394201.TGAGGTGT-TGAGGTGT_R1_U.trimmed.fastq.gz",
    "252_FD_52613.1.394201.TGAGGTGT-TGAGGTGT_R2_P.trimmed.fastq.gz",
    "252_FD_52613.1.394201.TGAGGTGT-TGAGGTGT_R2_U.trimmed.fastq.gz",
    "253_FD_52613.1.394201.CTGTTAGG-CTGTTAGG_R1_P.trimmed.fastq.gz",
    "253_FD_52613.1.394201.CTGTTAGG-CTGTTAGG_R1_U.trimmed.fastq.gz",
    "253_FD_52613.1.394201.CTGTTAGG-CTGTTAGG_R2_P.trimmed.fastq.gz",
    "253_FD_52613.1.394201.CTGTTAGG-CTGTTAGG_R2_U.trimmed.fastq.gz",
    "255_FD_52613.1.394201.CTAGGCAT-CTAGGCAT_R1_P.trimmed.fastq.gz",
    "255_FD_52613.1.394201.CTAGGCAT-CTAGGCAT_R1_U.trimmed.fastq.gz",
    "255_FD_52613.1.394201.CTAGGCAT-CTAGGCAT_R2_P.trimmed.fastq.gz",
    "255_FD_52613.1.394201.CTAGGCAT-CTAGGCAT_R2_U.trimmed.fastq.gz",
    "256_FD_52613.1.394201.ACTCGTTG-ACTCGTTG_R1_P.trimmed.fastq.gz",
    "256_FD_52613.1.394201.ACTCGTTG-ACTCGTTG_R1_U.trimmed.fastq.gz",
    "256_FD_52613.1.394201.ACTCGTTG-ACTCGTTG_R2_P.trimmed.fastq.gz",
    "256_FD_52613.1.394201.ACTCGTTG-ACTCGTTG_R2_U.trimmed.fastq.gz",
    "258_FD_52613.1.394201.ACACGGTT-ACACGGTT_R1_P.trimmed.fastq.gz",
    "258_FD_52613.1.394201.ACACGGTT-ACACGGTT_R1_U.trimmed.fastq.gz",
    "258_FD_52613.1.394201.ACACGGTT-ACACGGTT_R2_P.trimmed.fastq.gz",
    "258_FD_52613.1.394201.ACACGGTT-ACACGGTT_R2_U.trimmed.fastq.gz",
    "259_FD_52613.1.394201.CATGGCTA-CATGGCTA_R1_P.trimmed.fastq.gz",
    "259_FD_52613.1.394201.CATGGCTA-CATGGCTA_R1_U.trimmed.fastq.gz",
    "259_FD_52613.1.394201.CATGGCTA-CATGGCTA_R2_P.trimmed.fastq.gz",
    "259_FD_52613.1.394201.CATGGCTA-CATGGCTA_R2_U.trimmed.fastq.gz",
    "260_FD_52613.1.394201.GTAGCATC-GTAGCATC_R1_P.trimmed.fastq.gz",
    "260_FD_52613.1.394201.GTAGCATC-GTAGCATC_R1_U.trimmed.fastq.gz",
    "260_FD_52613.1.394201.GTAGCATC-GTAGCATC_R2_P.trimmed.fastq.gz",
    "260_FD_52613.1.394201.GTAGCATC-GTAGCATC_R2_U.trimmed.fastq.gz",
    "262_FD_52613.1.394201.CCTACTGA-CCTACTGA_R1_P.trimmed.fastq.gz",
    "262_FD_52613.1.394201.CCTACTGA-CCTACTGA_R1_U.trimmed.fastq.gz",
    "262_FD_52613.1.394201.CCTACTGA-CCTACTGA_R2_P.trimmed.fastq.gz",
    "262_FD_52613.1.394201.CCTACTGA-CCTACTGA_R2_U.trimmed.fastq.gz",
    "269_FD_52613.1.394201.TGATACGC-TGATACGC_R1_P.trimmed.fastq.gz",
    "269_FD_52613.1.394201.TGATACGC-TGATACGC_R1_U.trimmed.fastq.gz",
    "269_FD_52613.1.394201.TGATACGC-TGATACGC_R2_P.trimmed.fastq.gz",
    "269_FD_52613.1.394201.TGATACGC-TGATACGC_R2_U.trimmed.fastq.gz",
    "271_FD_52613.1.394201.TCCGTATG-TCCGTATG_R1_P.trimmed.fastq.gz",
    "271_FD_52613.1.394201.TCCGTATG-TCCGTATG_R1_U.trimmed.fastq.gz",
    "271_FD_52613.1.394201.TCCGTATG-TCCGTATG_R2_P.trimmed.fastq.gz",
    "271_FD_52613.1.394201.TCCGTATG-TCCGTATG_R2_U.trimmed.fastq.gz",
    "272_FD_52613.1.394201.GGATCTTC-GGATCTTC_R1_P.trimmed.fastq.gz",
    "272_FD_52613.1.394201.GGATCTTC-GGATCTTC_R1_U.trimmed.fastq.gz",
    "272_FD_52613.1.394201.GGATCTTC-GGATCTTC_R2_P.trimmed.fastq.gz",
    "272_FD_52613.1.394201.GGATCTTC-GGATCTTC_R2_U.trimmed.fastq.gz",
    "276_FD_52613.1.394201.GGTATAGG-GGTATAGG_R1_P.trimmed.fastq.gz",
    "276_FD_52613.1.394201.GGTATAGG-GGTATAGG_R1_U.trimmed.fastq.gz",
    "276_FD_52613.1.394201.GGTATAGG-GGTATAGG_R2_P.trimmed.fastq.gz",
    "276_FD_52613.1.394201.GGTATAGG-GGTATAGG_R2_U.trimmed.fastq.gz",
    "278_FD_52613.1.394201.GGAAGGAT-GGAAGGAT_R1_P.trimmed.fastq.gz",
    "278_FD_52613.1.394201.GGAAGGAT-GGAAGGAT_R1_U.trimmed.fastq.gz",
    "278_FD_52613.1.394201.GGAAGGAT-GGAAGGAT_R2_P.trimmed.fastq.gz",
    "278_FD_52613.1.394201.GGAAGGAT-GGAAGGAT_R2_U.trimmed.fastq.gz",
    "280_FD_52613.1.394201.TGTTGTGG-TGTTGTGG_R1_P.trimmed.fastq.gz",
    "280_FD_52613.1.394201.TGTTGTGG-TGTTGTGG_R1_U.trimmed.fastq.gz",
    "280_FD_52613.1.394201.TGTTGTGG-TGTTGTGG_R2_P.trimmed.fastq.gz",
    "280_FD_52613.1.394201.TGTTGTGG-TGTTGTGG_R2_U.trimmed.fastq.gz",
    "281_FD_52613.1.394201.TCCTGCTA-TCCTGCTA_R1_P.trimmed.fastq.gz",
    "281_FD_52613.1.394201.TCCTGCTA-TCCTGCTA_R1_U.trimmed.fastq.gz",
    "281_FD_52613.1.394201.TCCTGCTA-TCCTGCTA_R2_P.trimmed.fastq.gz",
    "281_FD_52613.1.394201.TCCTGCTA-TCCTGCTA_R2_U.trimmed.fastq.gz",
    "284_FD_52613.1.394201.CAATGTGG-CAATGTGG_R1_P.trimmed.fastq.gz",
    "284_FD_52613.1.394201.CAATGTGG-CAATGTGG_R1_U.trimmed.fastq.gz",
    "284_FD_52613.1.394201.CAATGTGG-CAATGTGG_R2_P.trimmed.fastq.gz",
    "284_FD_52613.1.394201.CAATGTGG-CAATGTGG_R2_U.trimmed.fastq.gz",
    "285_FD_52613.1.394201.CGAAGAAC-CGAAGAAC_R1_P.trimmed.fastq.gz",
    "285_FD_52613.1.394201.CGAAGAAC-CGAAGAAC_R1_U.trimmed.fastq.gz",
    "285_FD_52613.1.394201.CGAAGAAC-CGAAGAAC_R2_P.trimmed.fastq.gz",
    "285_FD_52613.1.394201.CGAAGAAC-CGAAGAAC_R2_U.trimmed.fastq.gz",
    "289_FD_52613.1.394201.TGAGCTAG-TGAGCTAG_R1_P.trimmed.fastq.gz",
    "289_FD_52613.1.394201.TGAGCTAG-TGAGCTAG_R1_U.trimmed.fastq.gz",
    "289_FD_52613.1.394201.TGAGCTAG-TGAGCTAG_R2_P.trimmed.fastq.gz",
    "289_FD_52613.1.394201.TGAGCTAG-TGAGCTAG_R2_U.trimmed.fastq.gz",
    "291_FD_52613.1.394201.CCGACTAT-CCGACTAT_R1_P.trimmed.fastq.gz",
    "291_FD_52613.1.394201.CCGACTAT-CCGACTAT_R1_U.trimmed.fastq.gz",
    "291_FD_52613.1.394201.CCGACTAT-CCGACTAT_R2_P.trimmed.fastq.gz",
    "291_FD_52613.1.394201.CCGACTAT-CCGACTAT_R2_U.trimmed.fastq.gz",
    "293_FD_52613.1.394201.GATACTGG-GATACTGG_R1_P.trimmed.fastq.gz",
    "293_FD_52613.1.394201.GATACTGG-GATACTGG_R1_U.trimmed.fastq.gz",
    "293_FD_52613.1.394201.GATACTGG-GATACTGG_R2_P.trimmed.fastq.gz",
    "293_FD_52613.1.394201.GATACTGG-GATACTGG_R2_U.trimmed.fastq.gz",
    "296_FD_52613.1.394201.AGGTGTAC-AGGTGTAC_R1_P.trimmed.fastq.gz",
    "296_FD_52613.1.394201.AGGTGTAC-AGGTGTAC_R1_U.trimmed.fastq.gz",
    "296_FD_52613.1.394201.AGGTGTAC-AGGTGTAC_R2_P.trimmed.fastq.gz",
    "296_FD_52613.1.394201.AGGTGTAC-AGGTGTAC_R2_U.trimmed.fastq.gz",
    ]

scripts = {}

# Group files based on prefixes
for file_name in file_names:
    prefix = file_name.split("_")[0]
    if prefix not in scripts:
        scripts[prefix] = []
    scripts[prefix].append(file_name)

# Generate bash scripts
for prefix, files in scripts.items():
    forward_reads = [file_name for file_name in files if "R1_P" in file_name]
    reverse_reads = [file_name for file_name in files if "R2_P" in file_name]
    forward_unpaired_reads = [file_name for file_name in files if "R1_U" in file_name]
    reverse_unpaired_reads = [file_name for file_name in files if "R2_U" in file_name]

    script_content = """#!/bin/bash
#PBS -N 2spades_{}
#PBS -j oe
#PBS -l ncpus=8
#PBS -l mem=150gb
#PBS -m abe
#PBS -l walltime=150:00:00
#PBS -M ballen3@go.olemiss.edu

module load spades
cd ~/slu_raw/deinterleaved_slu/redo_spades/all_redos_spades || exit

# Create a directory for the sample within the output directory
mkdir -p {}_output

spades.py -t 8 --careful --pe1-1 ./{} --pe1-2 ./{} --s1 ./{} --s1 ./{} -o {}_output
cd {}_output || exit
mv contigs.fasta {}_spades_contigs.fasta 
mv scaffolds.fasta {}_spades_scaffolds.fasta
mv spades.log {}_spades_prgm.log
mv contigs.paths {}_spades_contigs.paths
mv scaffolds.paths {}_spades_scaffolds.paths
mv assembly_graph_with_scaffolds.gfa {}_spades_assembly_graph.gfa
mv assembly_graph_after_simplification.gfa {}_spades_assembly_graph_after_simplification.gfa
mv assembly_graph.fastg {}_spades_assembly_graph.fastg
gzip -r {}_spades_*
""".format(prefix, prefix, ','.join(forward_reads), ','.join(reverse_reads), ','.join(forward_unpaired_reads),
           ','.join(reverse_unpaired_reads), prefix, prefix, prefix, prefix, prefix, prefix, prefix, prefix, prefix, prefix, prefix)

    script_filename = "spades_{}_script.sh".format(prefix)
    with open(script_filename, "w") as f:
        f.write(script_content)

    # Add execute permission to the script
    os.chmod(script_filename, 0o755)
    print("Generated bash script: {}".format(script_filename))


##### Use this short loop to submit all of the resulting scripts (after you run this script via the submit.sh script)
####  for file in *script.sh; do qsub $file; done ####