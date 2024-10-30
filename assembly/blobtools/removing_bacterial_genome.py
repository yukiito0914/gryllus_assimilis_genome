import pandas as pd
from Bio import SeqIO

### setting ###
blobtools_path = '/home/yuki_ito/work2/Tasks/blobtools/Jamaican/flye_new/blobtools_create_out.blobDB.table.txt'  
fasta_path = '/home/yuki_ito/work2/Tasks/Gryllus_assimilis/POLCA/J_flye_new/polca_3/polca_3.fa'       
output_fasta_path = '/home/yuki_ito/work2/Tasks/blobtools/Jamaican/flye_new/J_No_contami.fa' 

def filter_fasta(blobtools_path, fasta_path, output_fasta_path):
    
    blobtools = pd.read_csv(blobtools_path, sep='\t', header=None, skiprows=11)

  
    excluded_taxa = ['Proteobacteria', 'Firmicutes', 'Uroviricota', 'Bacteroidetes']
    contigs_to_keep = blobtools[~blobtools[5].isin(excluded_taxa)][0].tolist()


    filtered_sequences = (seq for seq in SeqIO.parse(fasta_path, 'fasta') if seq.id in contigs_to_keep)
    

    SeqIO.write(filtered_sequences, output_fasta_path, 'fasta')


filter_fasta(blobtools_path, fasta_path, output_fasta_path)
