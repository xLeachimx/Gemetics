RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

FactoryGirl.define do
	factory :default, class: GeneticObject do
		fitness 5
	end
end