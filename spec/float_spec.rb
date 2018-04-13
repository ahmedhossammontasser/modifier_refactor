require File.expand_path('spec_helper', File.dirname(__FILE__))
require 'float'
require 'rspec'


describe Float do
	context "#float" do
		context "should return a float" do
			input = 12.345
			it { expect(input.to_german_s).to eq("12,345") }
			it { expect(input.to_german_s).to be_a String }
		end
		context "should return a int" do
			input = 12.0
			it { expect(input.to_german_s).to eq("12,0") }
			it { expect(input.to_german_s).to be_a String }
		end

	end
end
