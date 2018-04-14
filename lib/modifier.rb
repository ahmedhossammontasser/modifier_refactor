require File.expand_path('combiner',File.dirname(__FILE__))
require 'string'
require 'float'

# input:
# - fiels paths , saleamount_factor, cancellation_factor
# output:
# - modify the values of the inputs files with base on the input entered by the user

class Modifier

	KEYWORD_UNIQUE_ID = 'Keyword Unique ID'
	LAST_VALUE_WINS = ['Account ID', 'Account Name', 'Campaign', 'Ad Group', 'Keyword', 'Keyword Type', 'Subid', 'Paused', 'Max CPC', 'Keyword Unique ID', 'ACCOUNT', 'CAMPAIGN', 'BRAND', 'BRAND+CATEGORY', 'ADGROUP', 'KEYWORD']
	LAST_REAL_VALUE_WINS = ['Last Avg CPC', 'Last Avg Pos']
	INT_VALUES = ['Clicks', 'Impressions', 'ACCOUNT - Clicks', 'CAMPAIGN - Clicks', 'BRAND - Clicks', 'BRAND+CATEGORY - Clicks', 'ADGROUP - Clicks', 'KEYWORD - Clicks']
	FLOAT_VALUES = ['Avg CPC', 'CTR', 'Est EPC', 'newBid', 'Costs', 'Avg Pos']
	NUM_COMMISSIONS = ['number of commissions']
	COMMISSIONS_VALUE = ['Commission Value', 'ACCOUNT - Commission Value', 'CAMPAIGN - Commission Value', 'BRAND - Commission Value', 'BRAND+CATEGORY - Commission Value', 'ADGROUP - Commission Value', 'KEYWORD - Commission Value']
	
	def initialize(saleamount_factor, cancellation_factor)
		@saleamount_factor = saleamount_factor
		@cancellation_factor = cancellation_factor
	end

	def modify(output, input , sort_by_column)
		input = FileHandler.sort(input, sort_by_column)
		input_enumerator = FileHandler.lazy_read(input)
		combiner = Combiner.new do |value|
			value[KEYWORD_UNIQUE_ID]
		end.combine(input_enumerator)
		merger = Enumerator.new do |yielder|
			while true
				begin
					list_of_rows = combiner.next
					merged = combine_hashes(list_of_rows)
					yielder.yield(combine_values(merged))
				rescue StopIteration
					break
				end
			end
		end
		FileHandler.write_modified_file(output , merger)
	end

	private
		def combine(merged)
			result = []
			merged.each do |_, hash|
				result << combine_values(hash)
			end
			result
		end

		def combine_values(hash)
			LAST_VALUE_WINS.each do |key|
				if hash.key?(key)
					hash[key] = hash[key].last
				end
			end
			LAST_REAL_VALUE_WINS.each do |key|
				if hash.key?(key)
					hash[key] = hash[key].select {|v| not (v.nil? or v == 0 or v == '0' or v == '')}.last
				end
			end
			INT_VALUES.each do |key|
				if hash.key?(key)
					hash[key] = hash[key][0].to_s
				end
			end
			FLOAT_VALUES.each do |key|
				if hash.key?(key)
					hash[key] = hash[key][0].from_german_to_f.to_german_s
				end
			end
			NUM_COMMISSIONS.each do |key|
				if hash.key?(key)
					hash[key] = (@cancellation_factor * hash[key][0].from_german_to_f).to_german_s
				end
			end
			COMMISSIONS_VALUE.each do |key|
				if hash.key?(key)
					hash[key] = (@cancellation_factor * @saleamount_factor * hash[key][0].from_german_to_f).to_german_s
				end
			end
			hash
		end

		def combine_hashes(list_of_rows)
			keys = []
			list_of_rows.each {|row| keys << row.headers}
			result = {}
			keys.flatten.each do |key|
				result[key] = []
				list_of_rows.each do |row|
					result[key] << (row.nil? ? nil : row[key])
				end
			end
			result
		end
end
