import re

def edit_gff_file(input_file, output_file):
    gene_name = ""
    mRNA_count = 0
    with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
        for line in f_in:
            fields = line.strip().split('\t')
            if len(fields) >= 9:
                feature_type = fields[2]
                attributes = fields[8]
                if feature_type == 'gene':
                    
                    match = re.search(r'Name=([^;\n]+)', attributes)
                    if match:
                        gene_name = match.group(1)
               
                    attributes = re.sub(r'ID=[^;\n]+', 'ID=' + gene_name, attributes)
                    mRNA_count = 0 
                elif feature_type == 'mRNA':
                    mRNA_count += 1 

                    attributes = re.sub(r'ID=[^;\n]+', 'ID=' + gene_name + '.' + str(mRNA_count), attributes)
                    attributes = re.sub(r'Parent=[^;\n]+', 'Parent=' + gene_name, attributes)
                elif feature_type in ['CDS', 'exon', 'three_prime_UTR', 'five_prime_UTR']:
            
                    match = re.search(r'Parent=([^;\n]+)', attributes)
                    if match:
                        feature_id = match.group(1)
                        attributes = re.sub(r'ID=[^;\n]+', 'ID=' + feature_id + '-' + gene_name, attributes)
                        attributes = re.sub(r'Parent=[^;\n]+', 'Parent=' + gene_name + '.' + str(mRNA_count), attributes)
                fields[8] = attributes
            f_out.write('\t'.join(fields) + '\n')

input_file = '/home/yuki_ito/work2/Tasks/gffcompare/Jamaican/UTR/tmp.gff'
output_file = '/home/yuki_ito/work2/Tasks/gffcompare/Jamaican/UTR/edited_final_annotation.gff'

edit_gff_file(input_file, output_file)
