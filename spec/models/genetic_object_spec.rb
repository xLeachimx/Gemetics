require 'spec_helper'

describe GeneticObject do
	context 'base class' do
		let(:obj){ build(:genetic_object) }

		it 'raises an error when mate is called' do
			expect{obj.mate(obj)}.to raise_error('Method Not Implemented')
		end

		it 'raises an error when mutate is called' do
			expect{obj.mutate()}.to raise_error('Method Not Implemented')
		end
	end
end