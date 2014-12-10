require 'spec_helper'

describe 'Option Validation' do
	context 'with no missing fields' do
		let(:options){
			{
				greaterBetter: true,
				totalPopReplace: true,
				genMax: 1000,
				selectionStyle: 'tournament',
				mutationPercent: 0.05,
				elitism: 0,
				debug: false,
				tournamentSize: 10,
			}
		}
		it 'passed require options validation' do
			expect(hasRequiredOptions(options)).to be(false)
		end

		it 'passed valid options validation' do
			expect(withinLimits(options,1)).to be(true)
		end

		context 'with inapproriate value for greaterBetter' do
			let(:options){
				{
					greaterBetter: nil,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails validation' do
				expect(withinLimits(options,1)).to be(false)
			end
		end

		context 'with inapproriate value for totalPopReplace' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: nil,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails validation' do
				expect(withinLimits(options,1)).to be(false)
			end
		end
		context 'with inapproriate value for genMax' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					genMax: -1,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails validation' do
				expect(withinLimits(options,1)).to be(false)
			end
		end
		context 'with inapproriate value for selectionStyle' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'nil',
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails validation' do
				expect(withinLimits(options,1)).to be(false)
			end
		end
		context 'with inapproriate value for mutationPercent' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: -0.05,
					elitism: 0,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails validation' do
				expect(withinLimits(options,1)).to be(false)
			end
		end
		context 'with inapproriate value for elitism' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: -1,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails validation' do
				expect(withinLimits(options,1)).to be(false)
			end
		end
		context 'with inapproriate value for debug' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					debug: nil,
					tournamentSize: 10,
				}
			}
			it 'fails validation' do
				expect(withinLimits(options,1)).to be(false)
			end
		end
		context 'with inapproriate value for the tournamentSize dependent option' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					tournamentSize: -1,
				}
			}
			it 'fails vaildation' do
				expect(dependentsOptionsWithinLimits(options,1)).to be(false)
			end
		end
	end

	context 'with missing fields' do
		context 'missing field greaterBetter' do
			let(:options){ 
				{
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails vaildation' do
				expect(hasRequiredOptions(options)).to be(false)
			end
		end

		context 'missing field totalPopReplace' do
			let(:options){
				{
					greaterBetter: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails vaildation' do
				expect(hasRequiredOptions(options)).to be(false)
			end
		end

		context 'missing field genMax' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails vaildation' do
				expect(hasRequiredOptions(options)).to be(false)
			end
		end

		context 'missing field selectionStyle' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					mutationPercent: 0.05,
					elitism: 0,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails vaildation' do
				expect(hasRequiredOptions(options)).to be(false)
			end
		end

		context 'missing field mutationPercent' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					elitism: 0,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails vaildation' do
				expect(hasRequiredOptions(options)).to be(false)
			end
		end

		context 'missing field elitism' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					debug: false,
					tournamentSize: 10,
				}
			}
			it 'fails vaildation' do
				expect(hasRequiredOptions(options)).to be(false)
			end
		end

		context 'missing field debug' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
					tournamentSize: 10,
				}
			}
			it 'fails vaildation' do
				expect(hasRequiredOptions(options)).to be(false)
			end
		end

		context 'missing dependent field tournamentSize' do
			let(:options){
				{
					greaterBetter: true,
					totalPopReplace: true,
					genMax: 1000,
					selectionStyle: 'tournament',
					mutationPercent: 0.05,
					elitism: 0,
				}
			}
			it 'fails vaildation' do
				expect(hasRequiredDependentOptions(options)).to be(false)
			end
		end
	end	
end