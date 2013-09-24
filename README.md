ruby-qualis-csv-parser
======================

Para aqueles que necessitam o Qualis completo em um formato de tabelas, já estão disponíveis três versões:
journal_qualis.csv # para a versão completa da lista.
journal_qualis_computing.csv # para a lista com apenas os qualis específicos de computação.
journal_qualis_filtered.csv # para a lista com resultados ligados a computação.



Para aqueles que queiram gerar as listas, basta seguir os passos abaixo.
1º Passo:
Caso não tenha o pacote libpoppler-dev em seu sistema Linux, o instale.
# para deb-based systems:
sudo apt-get install libpoppler-dev

2º Passo:
Em um ambiente linux, a partir do diretório downloads, execute:
pdftops Consulta_Webqualis.pdf

3º Passo:
Instale ruby caso não o tenha (https://rvm.io/).

4º Passo:
Rode os parsers de sua preferência em JournalDataParser:
ruby parse_all.rb # para gerar a versão completa da lista.
ruby parse_computing.rb # para gerar a lista com apenas os qualis específicos de computação.
ruby parse_filtered.rb # para gerar a lista com resultados ligados a computação.

