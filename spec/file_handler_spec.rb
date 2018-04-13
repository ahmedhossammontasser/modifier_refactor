require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'file_handler'
require 'rspec'

describe FileHandler do
	let(:file_path) { "#{Dir.pwd}/spec/files/project_2012-07-27_*_performancedata" }
	let(:sorted_file_path_click) { "#{Dir.pwd}/spec/files/project_2012-07-27_2012-12-21_performancedata.txt.sorted_click" }
	let(:sorted_file_path__num_of_comm) { "#{Dir.pwd}/spec/files/project_2012-07-27_2012-12-21_performancedata.txt.sorted_num_of_comm" }
	subject { FileHandler.latest(file_path) }

	context "#latest_file" do
		it "Should give the last by date file" do
			expect(File.basename(subject)).to eq('project_2012-07-27_2012-12-21_performancedata.txt')
		end
	end

	context "#sort by Click" do
		it "File should be sorted by Click column value" do
			sorted_file = FileHandler.sort(subject , 'Clicks')
			expect(File.read(sorted_file)).to eq(File.read(sorted_file_path_click))
		end
	end

	context "#sort by number_of_commissions" do
		it "File should be sorted by number_of_commissions column value" do
			sorted_file = FileHandler.sort(subject , 'number of commissions')
			expect(File.read(sorted_file)).to eq(File.read(sorted_file_path__num_of_comm))
		end
	end

end

##  lasted for wrong date raise error