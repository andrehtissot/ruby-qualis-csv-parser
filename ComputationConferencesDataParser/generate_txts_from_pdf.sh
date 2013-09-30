SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
DOWNLOADS_PATH="$SCRIPT_PATH/../downloaded"
echo "Start convertion to txt..."
pdftotext -f 3 -x 30 -y 80 -W 80 -H 700 "$DOWNLOADS_PATH/Comunicado_004_2012_Ciencia_da_Computacao.pdf" "$DOWNLOADS_PATH/Comunicado_004_2012_Ciencia_da_Computacao_short.txt"
pdftotext -f 3 -x 110 -y 80 -W 380 -H 700 "$DOWNLOADS_PATH/Comunicado_004_2012_Ciencia_da_Computacao.pdf" "$DOWNLOADS_PATH/Comunicado_004_2012_Ciencia_da_Computacao_name.txt"
pdftotext -f 3 -x 490 -y 80 -W 20 -H 700 "$DOWNLOADS_PATH/Comunicado_004_2012_Ciencia_da_Computacao.pdf" "$DOWNLOADS_PATH/Comunicado_004_2012_Ciencia_da_Computacao_hindex.txt"
pdftotext -f 3 -x 510 -y 80 -W 20 -H 700 "$DOWNLOADS_PATH/Comunicado_004_2012_Ciencia_da_Computacao.pdf" "$DOWNLOADS_PATH/Comunicado_004_2012_Ciencia_da_Computacao_rank.txt"
echo "Stop convertion to txt."
