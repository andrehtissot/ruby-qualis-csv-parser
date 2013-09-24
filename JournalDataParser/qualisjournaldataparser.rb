# encoding: UTF-8

class QualisJournalDataParser
	FIELDS = {
		ignore:['PLANEJAMENTO URBANO E REGIONAL / DEMOGRAFIA',
			'MEDICINA VETERINÁRIA', 'EDUCAÇÃO FÍSICA', 'ENFERMAGEM',
			'ZOOTECNIA / RECURSOS PESQUEIROS', 'MEDICINA III', 'MEDICINA II',
			'MEDICINA I', 'NUTRIÇÃO', 'ODONTOLOGIA', 'FARMÁCIA', 'BIOTECNOLOGIA',
			'QUÍMICA', 'ASTRONOMIA', 'GEOGRAFIA', 'BIODIVERSIDADE', 'MATERIAIS',
			'GEOGRAFIA', 'ASTRONOMIA / FÍSICA', 'PSICOLOGIA', 'EDUCAÇÃO',
			'SOCIOLOGIA', 'ANTROPOLOGIA / ARQUEOLOGIA', 'ENSINO',
			'LETRAS / LINGUÍSTICA', 'ECONOMIA', 'SERVIÇO SOCIAL', 'DIREITO',
			'ARQUITETURA E URBANISMO', 'FILOSOFIA/TEOLOGIA:subcomissão FILOSOFIA',
			'FILOSOFIA/TEOLOGIA:subcomissão TEOLOGIA', 'CIÊNCIAS AGRÁRIAS I',
			'CIÊNCIAS BIOLÓGICAS I', 'SAÚDE COLETIVA', 'GEOCIÊNCIAS',
			'CIÊNCIAS BIOLÓGICAS II', 'CIÊNCIAS BIOLÓGICAS III',
			'ARTES / MÚSICA', 'ADMINISTRAÇÃO, CIÊNCIAS CONTÁBEIS E TURISMO',
			'CIÊNCIAS AMBIENTAIS', 'HISTÓRIA', 'CIÊNCIA DE ALIMENTOS',
			'CIÊNCIA POLÍTICA E RELAÇÕES INTERNACIONAIS', 'CIÊNCIAS SOCIAIS APLICADAS I'],
		accept:['ENGENHARIAS III', 'ENGENHARIAS II', 'ENGENHARIAS I',
			'INTERDISCIPLINAR', 'ENGENHARIAS IV', 'CIÊNCIA DA COMPUTAÇÃO',
			'MATEMÁTICA / PROBABILIDADE E ESTATÍSTICA'],
		convert_keys:[], #generated
		convert:{'MATEMÁTICA / PROBABILIDADE E' => 'MATEMÁTICA / PROBABILIDADE E ESTATÍSTICA',
			'ADMINISTRAÇÃO, CIÊNCIAS CONTÁBEIS E' => 'ADMINISTRAÇÃO, CIÊNCIAS CONTÁBEIS E TURISMO',
			'CIÊNCIA POLÍTICA E RELAÇÕES' => 'CIÊNCIA POLÍTICA E RELAÇÕES INTERNACIONAIS',
			'PLANEJAMENTO URBANO E REGIONAL /' => 'PLANEJAMENTO URBANO E REGIONAL / DEMOGRAFIA'},
		converted_values_to_ignore:['TURISMO', 'INTERNACIONAIS', 'DEMOGRAFIA'],
	}
	STATI = {
		possibilities:['Em Atualização','Atualizado']
	}
	RANKS = {
		possibilities:['A1','A2','B1','B2','B3','B4','B5','C']
	}
	CHARSET_FIX = {
		prefix:'\3',
		convert:{'\301' => 'Á', '\302' => 'Â', '\303' => 'Ã', '\304' => 'Ä', '\306' => 'Æ',
			'\307' => 'Ç', '\310' => 'È', '\311' => 'É', '\312' => 'Ê', '\313' => 'Ë', '\314' => 'Ì',
			'\315' => 'Í', '\316' => 'Î', '\317' => 'Ï', '\321' => 'Ñ', '\322' => 'Ò', '\323' => 'Ó',
			'\324' => 'Ô', '\325' => 'Õ', '\326' => 'Ö', '\331' => 'Ù', '\332' => 'Ú', '\333' => 'Û',
			'\334' => 'Ü', '\335' => 'Ý', '\340' => 'à', '\341' => 'á', '\342' => 'â', '\343' => 'ã',
			'\344' => 'ä', '\346' => 'æ', '\347' => 'ç', '\350' => 'è', '\351' => 'é', '\352' => 'ê',
			'\353' => 'ë', '\354' => 'ì', '\355' => 'í', '\356' => 'î', '\357' => 'ï', '\361' => 'ñ',
			'\362' => 'ò', '\363' => 'ó', '\364' => 'ô', '\365' => 'õ', '\366' => 'ö', '\371' => 'ù',
			'\372' => 'ú', '\373' => 'û', '\374' => 'ü', '\375' => 'ý'},
		convert_keys:[] #generated
	}

	def header
		'ISSN,"Abbreviated Journal Title",Rank,Field,Status'
	end

	def create_file file_path
		open(file_path, 'w') { |f| f.puts header }
	end

	def load_configurations
		FIELDS[:convert_keys] = FIELDS[:convert].keys
		CHARSET_FIX[:convert_keys] = CHARSET_FIX[:convert].keys
	end

	def generate_csv input_file_path, output_file_path, options
		verbose_mode = options[:verbose] || false
		filter_fields = options[:filter].nil? ? nil : (options[:filter].is_a?(Array) ? options[:filter] : [options[:filter]])

		load_configurations

		File.delete output_file_path rescue nil

		create_file output_file_path unless File.size?(output_file_path)

		ignore_list = ['(Lista Completa)','(STATUS)','(ESTRATO)','(TÍTULO)','(ISSN)','(ÁREA DE AVALIAÇÃO)']

		stati_possibilities_to_check = STATI[:possibilities].map {|status| "(#{status})"} 
		ranks_possibilities_to_check = RANKS[:possibilities].map {|rank| "(#{rank})"}
		fields_converted_values_to_ignore = FIELDS[:converted_values_to_ignore].map {|field| "(#{field})"}
		fields_convert_keys_to_check = FIELDS[:convert_keys].map {|field| "(#{field})"}
		fields_to_ignore = FIELDS[:ignore].map {|field| "(#{field})"}
		fields_to_accept = FIELDS[:accept].map {|field| "(#{field})"}

		text = IO.read(input_file_path)
		lines = text.split "\r\n"
		lines = text.split "\n" if lines.size == 1

		puts 'Rules loaded.' if verbose_mode
		device_gray_counter = 0
		records = []
		record = {}
		total = 0
		skip_lines = 0

		lines.each_with_index do |line, line_number|
			if skip_lines > 0
				skip_lines -= 1
				next
			end

			next if line == '' || line == '()'
			if line == '[1 0 0 1 0 0] cm'
				if device_gray_counter == 9
					total+=1
					print "\r#{total} parsed" if verbose_mode
					if (total % 10000 == 0) || (total > 93550)
						records.reject! {|record| !(filter_fields.include?(record[:field]))} if filter_fields
						generate_csv_write_csv records, output_file_path
						records.clear
					end
					records << record
					record = {}
					device_gray_counter = 0
				else
					device_gray_counter += 1
				end
				next
			end
			next if (line[0] != '(') ||
				line.include?('%') ||
				fields_converted_values_to_ignore.include?(line) ||
				(line =~ /\(\d+\)/) ||
				(line =~ /\([A-Z][a-z]+\s\d\d\s[A-Z][a-z]+\s\d{4}\s\d\d:\d\d:\d\d\)/)

			if line =~ /\(\d{4}-\w{4}\)/
				record = generate_csv_set records, record, :issn, (line.match(/\d{4}-\w{4}/)[0])
				next
			end
			if ranks_possibilities_to_check.include? line
				record = generate_csv_set records, record, :rank, decapsulate_string(line)
				next
			end
			if stati_possibilities_to_check.include? line
				record = generate_csv_set records, record, :status, decapsulate_string(line)
				next
			end
			if line[line.length-1] == '\\'
				skip_lines = 0
				curr_line_number = line_number
				while line[line.length-1] == '\\'
					skip_lines+=1
					line = line[0..(line.length-2)]+lines[(curr_line_number+=1)]
				end
			end
			if line.include? CHARSET_FIX[:prefix]
				CHARSET_FIX[:convert_keys].each do |charset_fix_convert_key|
					if line.include? charset_fix_convert_key
						line = line.gsub charset_fix_convert_key, CHARSET_FIX[:convert][charset_fix_convert_key]
					end
				end
			end
			if ignore_list.include? line
				device_gray_counter = -1
				next
			end
			if fields_convert_keys_to_check.include? line
				record = generate_csv_convert_and_set_field records, record, decapsulate_string(line)
				next
			end
			if fields_to_accept.include?(line) || fields_to_ignore.include?(line)
				record = generate_csv_set records, record, :field, decapsulate_string(line)
				next
			end
			if line.length > 2 && line[line.length-1] == ')'
	 			record = generate_csv_set records, record, :journal, decapsulate_string(line)
		 		next
		 	end
		end

		records.reject! {|record| !(filter_fields.include?(record[:field]))} if filter_fields
		generate_csv_write_csv records, output_file_path
		print "\n" if verbose_mode
	end

	private
	def decapsulate_string string
		("#{(string.match(/\((.+)\)/) || [])[1]}").gsub("\\(", '(').gsub("\\)", ')')
	end
	def generate_csv_set records, record, attribute, line
		if (attribute == :journal) && !(record[:journal].nil?) && record[:status].nil?
			record[:journal] = "#{record[:journal]} #{line}"
		elsif record[attribute].nil?
			record[attribute] = line
		end
		record
	end
	def generate_csv_convert_and_set_field records, record, line
		FIELDS[:convert].each do |field_to_convert|
			return generate_csv_set(records, record, :field, field_to_convert[1]) if field_to_convert[0] == line
		end
	end
	def generate_csv_write_csv records, output_file_path
		CSV.open(output_file_path, "a+b") do |csv|
			records.each do |record|
				csv << [record[:issn], record[:journal], record[:rank], record[:field], record[:status]]
			end
		end
	end
end
