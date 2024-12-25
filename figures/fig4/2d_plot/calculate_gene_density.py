def calculate_gene_density(bed_file, fai_file, window_size):
    chrom_lengths = {}

    with open(fai_file, 'r') as fai:
        for line in fai:
            chrom, length = line.strip().split('\t')[:2]
            chrom_lengths[chrom] = int(length)

    with open(bed_file, 'r') as bed:
        gene_positions = {}
        for line in bed:
            chrom, start, end = line.strip().split('\t')[:3]
            start, end = int(start), int(end)
            if chrom not in gene_positions:
                gene_positions[chrom] = []
            gene_positions[chrom].append((start, end))

        for chrom in chrom_lengths.keys():
            if chrom in gene_positions:
                gene_count = 0
                for i in range(0, chrom_lengths[chrom], window_size):
                    window_start = i
                    window_end = min(i + window_size, chrom_lengths[chrom])
                    window_gene_count = 0
                    for gene_start, gene_end in gene_positions[chrom]:
                        if gene_end < window_start:
                            continue
                        if gene_start >= window_end:
                            break
                        window_gene_count += 1
                    gene_count += window_gene_count
                    gene_density = window_gene_count / window_size
                    print(chrom, window_start, window_end, gene_density)
            else:
                for i in range(0, chrom_lengths[chrom], window_size):
                    window_start = i
                    window_end = min(i + window_size, chrom_lengths[chrom])
                    print(chrom, window_start, window_end, 0.0)


bed_file = 'gene_v1.1.bed'
fai_file = 'gass_v1.1.genome.sm.fasta.fai'
window_size = 100000

calculate_gene_density(bed_file, fai_file, window_size)

