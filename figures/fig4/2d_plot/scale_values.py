def scale_values(input_file):
    data = []
    with open(input_file, 'r') as file:
        for line in file:
            values = line.strip().split()
            values[1:] = [float(value) for value in values[1:]]
            data.append(values)

    max_value = max(row[3] for row in data)

    scaled_data = [[row[0], int(row[1]), int(row[2]), row[3] / max_value] for row in data]

    return scaled_data

input_file = 'gene_density.tmp.txt'

scaled_data = scale_values(input_file)

output_file = 'gene_density.txt'

with open(output_file, 'w') as file:
    for row in scaled_data:
        file.write('{}\t{}\t{}\t{}\n'.format(row[0], row[1], row[2], row[3]))

