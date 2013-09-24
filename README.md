Parser do Qualis PDF para CSV
======================

Para aqueles que necessitam o Qualis completo em um formato de tabelas, já estão disponíveis três versões:<br />
journal_qualis.csv //para a versão completa da lista.<br />
journal_qualis_computing.csv //para a lista com apenas os qualis específicos de computação.<br />
journal_qualis_filtered.csv //para a lista com resultados ligados a computação.<br />
<br />

Para aqueles que queiram gerar as listas, basta seguir os passos abaixo.<br />
1º Passo:<br />
Caso não tenha o pacote libpoppler-dev em seu sistema Linux, o instale.<br />
sudo apt-get install libpoppler-dev //para sistemas baseados em debian

2º Passo:<br />
Em um ambiente linux, a partir do diretório downloads, execute:<br />
pdftops Consulta_Webqualis.pdf

3º Passo:<br />
Instale ruby caso não o tenha (https://rvm.io/).

4º Passo:<br />
Rode os parsers de sua preferência em JournalDataParser:<br />
ruby parse_all.rb //para gerar a versão completa da lista.<br />
ruby parse_computing.rb //para gerar a lista com apenas os qualis específicos de computação.<br />
ruby parse_filtered.rb //para gerar a lista com resultados ligados a computação.

