require 'csv'
require 'date'

# input:
# - files path 
# output:
# - parse file, sort file by columns name
# - get the file with the recent date (using regular expression) and create new file with the updated and editted values 
class FileHandler	
	LINES_PER_FILE = 120000
	DEFAULT_CSV_OPTIONS_READ = { :col_sep => "\t", :headers => :first_row }
	DEFAULT_CSV_OPTIONS_WRITE = { :col_sep => "\t", :headers => :first_row, :row_sep => "\r\n" }

	def self.latest(name)
		files = Dir["#{name}*.txt"]
		files.sort_by! do |file|
			/(?<last_date>\d+-\d+-\d+)_[[:alpha:]]+\.txt$/ =~ file
			DateTime.parse(last_date)
		end
		throw RuntimeError if files.empty?
		files.last
	end


	# input:
	# - file_name = path to the input file
	# - sort_by_column = string reprsented which column will be used to sort the file 
	# output:
	# - csv file sorted by sort_by_column Column
	def self.sort(file_name , sort_by_column)
		output = "#{file_name}.sorted"
		content_as_table = parse(file_name)
		headers = content_as_table.headers
		index_of_key = headers.index(sort_by_column)
		content = content_as_table.sort_by { |a| -a[index_of_key].to_i }
		write(content, headers, output)
		return output
	end

	def self.parse(file)
		CSV.read(file, DEFAULT_CSV_OPTIONS_READ)
	end

	def self.lazy_read(file)
		Enumerator.new do |yielder|
			CSV.foreach(file, DEFAULT_CSV_OPTIONS_READ) do |row|
				yielder.yield(row)
			end
		end
	end

	def self.write(content, headers, output)
		CSV.open(output, "wb",  DEFAULT_CSV_OPTIONS_WRITE ) do |csv|
			csv << headers
			content.each do |row|
				csv << row
			end
		end
	end

	def self.write_modified_file(output , merger)
		done = false
		file_index = 0
		file_name = output.gsub('.txt', '')
		while not done do
			CSV.open(file_name + "_#{file_index}.txt", "wb", DEFAULT_CSV_OPTIONS_WRITE) do |csv|
				headers_written = false
				line_count = 0
				while line_count < LINES_PER_FILE
					begin
						merged = merger.next
						if not headers_written
							csv << merged.keys
							headers_written = true
							line_count +=1
						end
						csv << merged
						line_count +=1
					rescue StopIteration
						done = true
						break
					end
				end
				file_index += 1
			end
		end		
	end
end