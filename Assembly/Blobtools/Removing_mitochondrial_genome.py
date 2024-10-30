# Extract mitochondrial genomes common to megablast.out and blobDB.table.txt in mito_extraction.ipynb and output them in order of coverage

import pandas as pd

### setting ###
input_file_path_megablast = '/home/yuki_ito/work2/Tasks/blobtools/Jamaican/flye_new/assembly.fasta.vs.nt.megablast.out'
input_file_path_blobtools = '/home/yuki_ito/work2/Tasks/blobtools/Jamaican/flye_new/blobtools_create_out.blobDB.table.txt'
output_file_path_final = '/home/yuki_ito/work2/Tasks/blobtools/Jamaican/flye_new/BLobtools_final_output.tsv'


mitochondrion_data = []
with open(input_file_path_megablast, 'r') as infile:
    for line in infile:
        if 'mitochondrion' in line:
            mitochondrion_data.append(line.strip().split('\t'))

blobtools = pd.read_csv(input_file_path_blobtools, sep='\t', header=None, skiprows=11)


mitochondrion_df = pd.DataFrame(mitochondrion_data)


common_contigs = blobtools[blobtools[0].isin(mitochondrion_df[0])]


sorted_data = common_contigs.sort_values(by=[4], ascending=False)


headers = ["name", "length", "GC", "N", "bam0", "phylum.t.6%s", "phylum.s.7%s", "phylum.c.8"]
sorted_data.to_csv(output_file_path_final, sep='\t', index=False, header=headers)
