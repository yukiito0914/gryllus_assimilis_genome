### setting ###
WOR_DIR="/home/yuki_ito/work2/Tasks/MaSuRCA/masurca_Jamaican_dorado2"
Config="/home/yuki_ito/work2/Tasks/MaSuRCA/config.txt"

### masurca ###
conda activate polca
cd $WOR_DIR
masurca $Config -o assemble.sh
./assemble.sh
