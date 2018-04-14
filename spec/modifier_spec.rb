require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'modifier'
require 'file_handler'

describe Modifier do
  context '#modify' do

    let(:sorted) { "#{Dir.pwd}/spec/files/sorted.txt" }
    let(:file_path) { "#{Dir.pwd}/spec/files/project_2012-07-27_2012-12-31_performancedata" }
    let(:modified)  { "#{Dir.pwd}/spec/files/project_2012-07-27_2012-12-31_performancedata_0.txt" }
  
    subject { FileHandler.latest(file_path) }

    context "#modify with couple of 'equal' inputs" do

      it "should modify a file " do
        File.directory?(modified).should be false
        Modifier.new( 1,  0.5).modify(subject, subject , "Clicks")
        expect(File.read(modified)).to eq(File.read(sorted))
        File.delete(modified)
        File.directory?(modified).should be false
      end
    end
  end
end 