require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'string'
require 'rspec'


describe String do
	context "#string" do
		context "should return a float" do
			input = "12,345"
			it { expect(input.from_german_to_f).to eq(12.345) }
			it { expect(input.from_german_to_f).to be_a Float }
		end

		context "should raise expection for invalid input multiple ," do
			input = "12,345,0"
			it "raises" do
				expect { input.from_german_to_f }.to raise_error
			end
		end

		context "should raise expection for invalid input multiple , and ." do
			input = "12,345.0"
			it "raises" do
				expect { input.from_german_to_f }.to raise_error
			end
		end		
		
		context "should raise expection for invalid string input" do
			input = "12,345.0a"
			it "raises" do
				expect { input.from_german_to_f }.to raise_error
			end
		end		
	end
end
