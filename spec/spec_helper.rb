require 'rubygems'
require 'factory_girl'

require_relative '../lib/genetic_object'
require_relative '../spec/factories/genetic_object'


RSpec.configure do |config|
	config.include FactoryGirl::Syntax::Methods
end