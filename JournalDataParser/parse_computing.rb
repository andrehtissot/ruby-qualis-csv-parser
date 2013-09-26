# encoding: UTF-8

QUALIS_PATH = File.absolute_path(File.dirname(__FILE__)+'/../')
require "#{QUALIS_PATH}/JournalDataParser/qualisjournaldataparser.rb"

puts "Start parsing Qualis..."
QualisJournalDataParser.new.generate_csv "#{QUALIS_PATH}/downloaded/Consulta_Webqualis.ps", "#{QUALIS_PATH}/parsed/journal_qualis_computing.csv",
	{verbose:true, filter:'CIÊNCIA DA COMPUTAÇÃO'}
puts "Stop parsing Qualis."
