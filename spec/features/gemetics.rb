require 'spec_helper'

describe 'Options' do
	context 'with no missing fields' do
	end

	context 'with missing fields' do
		context 'missing field greaterBetter' do
			before do
				options = {
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
				}
			end
			it 'fails vaildation' do
				expect(hasrequiredOptions(options)).to be(false)
			end
		end

		context 'missing field totalPopReplace' do
			before do
				options = {
					greaterBetter: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
				}
			end
			it 'raises a vaildation warning' do
				expect(hasrequiredOptions(options)).to be(false)
			end
		end

		context 'missing field genMax' do
			before do
				options = {
					greaterBetter: true,
					totalPopReplace: true,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
				}
			end
			it 'raises a vaildation warning' do
				expect(hasrequiredOptions(options)).to be(false)
			end
		end

		context 'missing field selectionStyle' do
			before do
				options = {
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
				}
			end
			it 'raises a vaildation warning' do
				expect(hasrequiredOptions(options)).to be(false)
			end
		end

		context 'missing field mutationPercent' do
			before do
				options = {
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					elitism: 0,
					debug: false,
				}
			end
			it 'raises a vaildation warning' do
				expect(hasrequiredOptions(options)).to be(false)
			end
		end

		context 'missing field elitism' do
			before do
				options = {
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					debug: false,
				}
			end
			it 'raises a vaildation warning' do
				expect(hasrequiredOptions(options)).to be(false)
			end
		end

		context 'missing field debug' do
			before do
				options = {
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
				}
			end
			it 'raises a vaildation warning' do
				expect(hasrequiredOptions(options)).to be(false)
			end
		end
	end	
end