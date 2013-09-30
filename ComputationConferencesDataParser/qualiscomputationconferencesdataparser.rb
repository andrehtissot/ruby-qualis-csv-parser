# encoding: UTF-8
require 'csv'

class QualisComputationConferencesDataParser
	def header
		'"Abbreviated Conference Title","Abbreviated Journal Title","H Index",Rank'
	end

	def create_file file_path
		open(file_path, 'w') { |f| f.puts header }
	end

	def generate_csv input_files_paths, output_file_path
		File.delete output_file_path rescue nil
		create_file output_file_path

		loaded_values = {}
		[:short, :name, :hindex, :rank].each do |attribute|
			loaded_values[attribute] = []
			text = IO.read(input_files_paths[attribute])
			lines = text.split "\r\n"
			lines = text.split "\n" if lines.size == 1
			lines.each do |line|
				next if line == '' || line == "\f"
				if attribute == :short || attribute == :name
					line = line.gsub(/\-\u{ad}\u{2010}/, '-').gsub(/\t\r /, '')
				end
				loaded_values[attribute] << line.gsub(/\f/,'').gsub(/^[\s\u{a0}]+/, '')
					.gsub(/[\s\u{a0}]+$/, '')
			end
		end

		CSV.open(output_file_path, "a+b") do |csv|
			total = loaded_values[:short].size
			0.upto(total-1) do |index|
				csv << [loaded_values[:short][index], loaded_values[:name][index],
					loaded_values[:hindex][index], loaded_values[:rank][index]]
			end
		end
	end
end
