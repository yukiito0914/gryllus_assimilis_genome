from Bio import SeqIO

def calculate_gc_content(fasta_file, fai_file, window_size, output_file):
    chrom_lengths = {}

    # Read the FAI file to get chromosome lengths
    with open(fai_file, 'r') as fai:
        for line in fai:
            chrom, length = line.strip().split('\t')[:2]  # Extract chromosome name and length
            chrom_lengths[chrom] = int(length)  # Store lengths as integers

    gc_content_data = []

    # Read the FASTA file and calculate GC content
    for record in SeqIO.parse(fasta_file, "fasta"):
        chrom = record.id  # Get the chromosome name
        sequence = str(record.seq)  # Get the sequence as a string
        if chrom in chrom_lengths:  # Check if the chromosome is in the FAI data
            for i in range(0, chrom_lengths[chrom], window_size):  # Iterate in windows
                window_start = i  # Start position of the window
                window_end = min(i + window_size, chrom_lengths[chrom])  # End position of the window
                window_seq = sequence[window_start:window_end]  # Extract the sequence for the window
                gc_count = window_seq.count('G') + window_seq.count('C')  # Count G and C bases
                gc_content = gc_count / len(window_seq) if len(window_seq) > 0 else 0  # Calculate GC content
                gc_content_data.append([chrom, window_start, window_end, gc_content])  # Store results

    # Write the results to a file
    with open(output_file, 'w') as out:
        for data in gc_content_data:
            out.write(f"{data[0]}\t{data[1]}\t{data[2]}\t{data[3]}\n")  # Write chromosome, start, end, GC content

def scale_values(input_file, output_file):
    data = []
    with open(input_file, 'r') as file:
        for line in file:
            values = line.strip().split()  # Split the line into columns
            values[1:] = [float(value) for value in values[1:]]  # Convert columns 2 and beyond to floats
            data.append(values)  # Append the line data to the list

    max_value = max(row[3] for row in data)  # Find the maximum GC content value

    # Scale GC content values by dividing by the maximum value
    scaled_data = [[row[0], int(row[1]), int(row[2]), row[3] / max_value] for row in data]

    # Write the scaled data to a file
    with open(output_file, 'w') as file:
        for row in scaled_data:
            file.write('{}\t{}\t{}\t{}\n'.format(row[0], row[1], row[2], row[3]))  # Write chromosome, start, end, scaled GC content

def main():
    fasta_file = 'gass_v1.1.genome.sm.fasta'  # Path to the input FASTA file
    fai_file = 'gass_v1.1.genome.sm.fasta.fai'  # Path to the FAI file
    window_size = 100000  # Size of the sliding window in bases
    gc_content_file = 'gc_content.tmp.txt'  # Temporary file for raw GC content results
    scaled_gc_content_file = 'gc_content.txt'  # Output file for scaled GC content

    # Calculate GC content from the FASTA file and write to the temporary file
    calculate_gc_content(fasta_file, fai_file, window_size, gc_content_file)

    # Scale the GC content values and write to the final output file
    scale_values(gc_content_file, scaled_gc_content_file)

if __name__ == "__main__":
    main()
