from Bio import SeqIO
import os

single_ortholog_seq_DIR = "/work/sanno/Orthofinder/output/OrthoFinder/Results_Apr05/Single_Copy_Orthologue_Sequences"
out_path = "/work/sanno/Orthofinder/output/analysis/rename"

new_ids = [
    "Acheta_domesticus",
    "Apteronemobius_asahinai",
    "Gryllus_assimilis",
    "Gryllus_bimaculatus",
    "Gryllus_longicercus",
    "Laupala_kohalensis",
    "Locusta_migratoria",
    "Schistocerca_gregaria",
    "Teleogryllus_occipitalis"
]

for file in os.listdir(single_ortholog_seq_DIR):
    input_path = os.path.join(single_ortholog_seq_DIR, file)
    output_path = os.path.join(out_path, f"{file.split('.')[0]}.fasta")

    sequences = list(SeqIO.parse(input_path, 'fasta'))

    with open(output_path, 'w') as output_handle:
        for seq_record, new_id in zip(sequences, new_ids):
            seq_record.id = new_id
            seq_record.description = ""  
            SeqIO.write(seq_record, output_handle, 'fasta')
