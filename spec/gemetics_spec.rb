require 'gemetics'
RSpec.describe GeneticObject do
  context 'with base class' do
    let(:obj){ create(:default) }
  	describe 'mate method' do
  		it "raises and error when called" do
        expect(obj.mate).to raise_error('Method Not Implemented')
  		end
  	end

  	describe 'mutate method' do
  		it "raises and error when called" do
        expect(obj.mutate).to raise_error('Method Not Implemented')
  		end
  	end
  end

end