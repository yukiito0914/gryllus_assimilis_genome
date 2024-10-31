### setting ###
infile_gff="/home/yuki_ito/work2/Data/Jamaican/edited_final_annotation.gff"
out_gff="/home/yuki_ito/work2/Data/Jamaican/agat_edited_final_annotation.gff"

### agat ###
conda activate agat 
## Check if input file exists
if [[ ! -f $infile_gff ]]; then
    echo "Input file not found: $infile_gff"
    exit 1
fi

## Set PERL5LIB to include Conda's Perl modules path
export PERL5LIB=/home/yuki_ito/anaconda3/envs/agat/lib/perl5/5.32/site_perl:/home/yuki_ito/anaconda3/envs/agat/lib/perl5/site_perl/x86_64-linux-thread-multi:/home/yuki_ito/anaconda3/envs/agat/lib/perl5/site_perl:/home/yuki_ito/anaconda3/envs/agat/lib/perl5/5.32/vendor_perl:/home/yuki_ito/anaconda3/envs/agat/lib/perl5/vendor_perl:/home/yuki_ito/anaconda3/envs/agat/lib/perl5/5.32/core_perl:/home/yuki_ito/anaconda3/envs/agat/lib/perl5/core_perl

## Use the correct Perl executable
export PATH=/home/yuki_ito/anaconda3/envs/agat/bin:$PATH

echo "Running AGAT tool..."
/home/yuki_ito/anaconda3/envs/agat/bin/perl /home/yuki_ito/anaconda3/envs/agat/bin/agat_convert_sp_gxf2gxf.pl -g $infile_gff -o $out_gff
