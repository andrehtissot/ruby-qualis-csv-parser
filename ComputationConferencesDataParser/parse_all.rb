QUALIS_PATH = File.absolute_path(File.dirname(__FILE__)+'/../')
require "#{QUALIS_PATH}/ComputationConferencesDataParser/qualiscomputationconferencesdataparser.rb"

puts "Start parsing Qualis..."
QualisComputationConferencesDataParser.new.generate_csv ({
	short:"#{QUALIS_PATH}/downloaded/Comunicado_004_2012_Ciencia_da_Computacao_short.txt",
	name:"#{QUALIS_PATH}/downloaded/Comunicado_004_2012_Ciencia_da_Computacao_name.txt",
	rank:"#{QUALIS_PATH}/downloaded/Comunicado_004_2012_Ciencia_da_Computacao_rank.txt",
	hindex:"#{QUALIS_PATH}/downloaded/Comunicado_004_2012_Ciencia_da_Computacao_hindex.txt"
}), "#{QUALIS_PATH}/parsed/computation_conferences_qualis.csv"
puts "Stop parsing Qualis."
