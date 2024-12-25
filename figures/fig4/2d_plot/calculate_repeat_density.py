def gff_to_bed(gff_file, bed_file):
    # Convert GFF file to BED format
    with open(gff_file, 'r') as gff, open(bed_file, 'w') as bed:
        for line in gff:
            if line.startswith('#'):  # Skip comment lines
                continue
            fields = line.strip().split('\t')  # Split line into fields
            if len(fields) >= 5:  # Ensure there are enough fields
                chrom = fields[0]  # Get chromosome name
                start = fields[3]  # Get start position
                end = fields[4]  # Get end position
                bed.write(f"{chrom}\t{start}\t{end}\n")  # Write to BED file

def calculate_repeat_density(bed_file, fai_file, window_size, output_file):
    chrom_lengths = {}

    # Read the FAI file to get chromosome lengths
    with open(fai_file, 'r') as fai:
        for line in fai:
            chrom, length = line.strip().split('\t')[:2]  # Extract chromosome name and length
            chrom_lengths[chrom] = int(length)  # Store length as integer

    # Read the BED file to get repeat positions
    with open(bed_file, 'r') as bed:
        repeat_positions = {}
        for line in bed:
            chrom, start, end = line.strip().split('\t')[:3]  # Extract chromosome, start, and end
            start, end = int(start), int(end)  # Convert positions to integers
            if chrom not in repeat_positions:
                repeat_positions[chrom] = []  # Initialize list for chromosome if not present
            repeat_positions[chrom].append((start, end))  # Add repeat position tuple

    # Write results to the output file
    with open(output_file, 'w') as out:
        # Calculate repeat density for each chromosome based on window size
        for chrom in chrom_lengths.keys():
            if chrom in repeat_positions:  # If repeats exist for the chromosome
                for i in range(0, chrom_lengths[chrom], window_size):
                    window_start = i  # Define window start
                    window_end = min(i + window_size, chrom_lengths[chrom])  # Define window end
                    window_repeat_count = 0  # Initialize repeat count
                    for repeat_start, repeat_end in repeat_positions[chrom]:
                        if repeat_end < window_start:  # Skip repeats before the window
                            continue
                        if repeat_start >= window_end:  # Stop checking repeats after the window
                            break
                        window_repeat_count += 1  # Count repeats overlapping the window
                    repeat_density = window_repeat_count / window_size  # Calculate repeat density
                    out.write(f"{chrom}\t{window_start}\t{window_end}\t{repeat_density}\n")  # Write results
            else:
                # If no repeats for the chromosome, set repeat density to 0
                for i in range(0, chrom_lengths[chrom], window_size):
                    window_start = i
                    window_end = min(i + window_size, chrom_lengths[chrom])
                    out.write(f"{chrom}\t{window_start}\t{window_end}\t0.0\n")

def scale_values(input_file, output_file):
    # Scale values in the input file to normalize them
    data = []
    with open(input_file, 'r') as file:
        for line in file:
            values = line.strip().split()  # Split line into columns
            values[1:] = [float(value) for value in values[1:]]  # Convert numeric columns to floats
            data.append(values)  # Append line data to the list

    max_value = max(row[3] for row in data)  # Find the maximum value in the 4th column

    # Scale values by dividing by the maximum value
    scaled_data = [[row[0], int(row[1]), int(row[2]), row[3] / max_value] for row in data]

    # Write scaled data to the output file
    with open(output_file, 'w') as file:
        for row in scaled_data:
            file.write('{}\t{}\t{}\t{}\n'.format(row[0], row[1], row[2], row[3]))

def main():
    gff_file = 'gass_v1.0_unmasked.fasta.out.gff'  # Path to the input GFF file
    bed_file = 'repeat_v1.1.bed'  # Path to the intermediate BED file
    fai_file = 'gass_v1.1.genome.sm.fasta.fai'  # Path to the FAI file
    window_size = 100000  # Window size for repeat density calculation
    repeat_density_file = 'repeat_density.tmp.txt'  # Path to the intermediate repeat density file
    scaled_repeat_density_file = 'repeat_density.txt'  # Path to the scaled repeat density file

    # Convert GFF file to BED file
    gff_to_bed(gff_file, bed_file)

    # Calculate repeat density from BED file and write to a temporary file
    calculate_repeat_density(bed_file, fai_file, window_size, repeat_density_file)

    # Scale repeat density values and write to the final output file
    scale_values(repeat_density_file, scaled_repeat_density_file)

if __name__ == "__main__":
    main()
