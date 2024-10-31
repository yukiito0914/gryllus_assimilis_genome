# Create a gene list
grep '^>' /home/yuki_ito/work2/Tasks/gffread/Futahoshi_ito/futahoshi_iyu/protein_UTR.fasta | sed 's/^>//' > /home/yuki_ito/work2/Tasks/blast/Futahoshi_iyu/new_gene_list.txt
