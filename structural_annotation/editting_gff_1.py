import re

def edit_gff_file(input_file, output_file, search_string, replacement_string):
    with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
        for line in f_in:
            fields = line.strip().split('\t')
            if len(fields) >= 9:
                attributes = fields[8]
                # ‘GassScaffold_’ replaced by ’Gass.’
                attributes = attributes.replace(search_string, replacement_string)
                
                fields[8] = attributes
            f_out.write('\t'.join(fields) + '\n')


input_file = '/home/yuki_ito/work2/Tasks/gffcompare/Jamaican/UTR/final_annotation.gff'
output_file = '/home/yuki_ito/work2/Tasks/gffcompare/Jamaican/UTR/tmp.gff'
search_string = 'GassSuper-Scaffold_'
replacement_string = 'Gass'

edit_gff_file(input_file, output_file, search_string, replacement_string)
