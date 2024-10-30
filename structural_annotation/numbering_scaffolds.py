from Bio import SeqIO
import pandas as pd

### Setting ###
genome = '/work3/yuki_ito/out/3D_DNA/Jamaican/draft.FINAL.sorted.fasta'
output_dir = '/home/yuki_ito/work2/Tasks/RepeatMask/Jamaican'

### Command ###
fasta_in = open(genome)
counter = 1
for record in SeqIO.parse(fasta_in, 'fasta'):
    seq = record.seq
    with open(f'{output_dir}/draft_genome.sort.rename.fasta', mode='a') as f:
        f.write(f'>Super-Scaffold_{counter}\n')
        f.write(f'{seq}\n')
    counter += 1
