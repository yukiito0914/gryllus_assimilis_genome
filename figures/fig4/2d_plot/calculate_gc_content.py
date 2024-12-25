from Bio import SeqIO

def calculate_gc_content(fasta_file, fai_file, window_size, output_file):
    chrom_lengths = {}

    # FAIファイルを読み込み、染色体の長さを取得
    with open(fai_file, 'r') as fai:
        for line in fai:
            chrom, length = line.strip().split('\t')[:2]
            chrom_lengths[chrom] = int(length)

    gc_content_data = []

    # FASTAファイルを読み込み、GC contentを計算
    for record in SeqIO.parse(fasta_file, "fasta"):
        chrom = record.id
        sequence = str(record.seq)
        if chrom in chrom_lengths:
            for i in range(0, chrom_lengths[chrom], window_size):
                window_start = i
                window_end = min(i + window_size, chrom_lengths[chrom])
                window_seq = sequence[window_start:window_end]
                gc_count = window_seq.count('G') + window_seq.count('C')
                gc_content = gc_count / len(window_seq) if len(window_seq) > 0 else 0
                gc_content_data.append([chrom, window_start, window_end, gc_content])

    # 結果をファイルに出力
    with open(output_file, 'w') as out:
        for data in gc_content_data:
            out.write(f"{data[0]}\t{data[1]}\t{data[2]}\t{data[3]}\n")

def scale_values(input_file, output_file):
    data = []
    with open(input_file, 'r') as file:
        for line in file:
            values = line.strip().split()
            values[1:] = [float(value) for value in values[1:]]
            data.append(values)

    max_value = max(row[3] for row in data)

    scaled_data = [[row[0], int(row[1]), int(row[2]), row[3] / max_value] for row in data]

    with open(output_file, 'w') as file:
        for row in scaled_data:
            file.write('{}\t{}\t{}\t{}\n'.format(row[0], row[1], row[2], row[3]))

def main():
    fasta_file = 'gass_v1.1.genome.sm.fasta'  # Replace with the path to your FASTA file
    fai_file = 'gass_v1.1.genome.sm.fasta.fai'
    window_size = 100000
    gc_content_file = 'gc_content.tmp.txt'
    scaled_gc_content_file = 'gc_content.txt'

    # FASTAファイルからGC contentを計算し、結果を一時ファイルに出力
    calculate_gc_content(fasta_file, fai_file, window_size, gc_content_file)

    # 一時ファイルをスケーリングし、最終的なファイルに出力
    scale_values(gc_content_file, scaled_gc_content_file)

if __name__ == "__main__":
    main()
