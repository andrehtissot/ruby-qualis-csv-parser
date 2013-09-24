QUALIS_PATH = File.absolute_path(File.dirname(__FILE__)+'/../')
require 'csv'
require "#{QUALIS_PATH}/JournalDataParser/qualisjournaldataparser.rb"

puts "Start parsing Qualis..."
QualisJournalDataParser.new.generate_csv "#{QUALIS_PATH}/downloaded/Consulta_Webqualis.ps", "#{QUALIS_PATH}/journal_qualis_filtered.csv",
	{verbose:true, filter:(QualisJournalDataParser::FIELDS[:accept])}
puts "Stop parsing Qualis."
exit