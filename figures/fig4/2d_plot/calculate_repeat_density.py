def gff_to_bed(gff_file, bed_file):
    with open(gff_file, 'r') as gff, open(bed_file, 'w') as bed:
        for line in gff:
            if line.startswith('#'):
                continue
            fields = line.strip().split('\t')
            if len(fields) >= 5:
                chrom = fields[0]
                start = fields[3]
                end = fields[4]
                bed.write(f"{chrom}\t{start}\t{end}\n")

def calculate_repeat_density(bed_file, fai_file, window_size, output_file):
    chrom_lengths = {}

    # FAIファイルを読み込み、染色体の長さを取得
    with open(fai_file, 'r') as fai:
        for line in fai:
            chrom, length = line.strip().split('\t')[:2]
            chrom_lengths[chrom] = int(length)

    # BEDファイルを読み込み、リピートの位置を取得
    with open(bed_file, 'r') as bed:
        repeat_positions = {}
        for line in bed:
            chrom, start, end = line.strip().split('\t')[:3]
            start, end = int(start), int(end)
            if chrom not in repeat_positions:
                repeat_positions[chrom] = []
            repeat_positions[chrom].append((start, end))

    # 結果をファイルに出力
    with open(output_file, 'w') as out:
        # 各染色体ごとにウィンドウサイズに基づいてリピート密度を計算
        for chrom in chrom_lengths.keys():
            if chrom in repeat_positions:
                for i in range(0, chrom_lengths[chrom], window_size):
                    window_start = i
                    window_end = min(i + window_size, chrom_lengths[chrom])
                    window_repeat_count = 0
                    for repeat_start, repeat_end in repeat_positions[chrom]:
                        if repeat_end < window_start:
                            continue
                        if repeat_start >= window_end:
                            break
                        window_repeat_count += 1
                    repeat_density = window_repeat_count / window_size
                    out.write(f"{chrom}\t{window_start}\t{window_end}\t{repeat_density}\n")
            else:
                for i in range(0, chrom_lengths[chrom], window_size):
                    window_start = i
                    window_end = min(i + window_size, chrom_lengths[chrom])
                    out.write(f"{chrom}\t{window_start}\t{window_end}\t0.0\n")

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
    gff_file = 'gass_v1.0_unmasked.fasta.out.gff'  # Replace with the path to your GFF file
    bed_file = 'repeat_v1.1.bed'
    fai_file = 'gass_v1.1.genome.sm.fasta.fai'
    window_size = 100000
    repeat_density_file = 'repeat_density.tmp.txt'
    scaled_repeat_density_file = 'repeat_density.txt'

    # GFFファイルからBEDファイルを作成
    gff_to_bed(gff_file, bed_file)

    # BEDファイルを使ってリピート密度を計算し、結果を一時ファイルに出力
    calculate_repeat_density(bed_file, fai_file, window_size, repeat_density_file)

    # 一時ファイルをスケーリングし、最終的なファイルに出力
    scale_values(repeat_density_file, scaled_repeat_density_file)

if __name__ == "__main__":
    main()