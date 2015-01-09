require 'gemetics'
require 'genetic_object'

class GeneticString < GeneticObject
	attr_accessor :chromosome
	@@possible_characters = ('a'..'z').to_a + ('A'..'Z').to_a + [',', ' ', '.', '?', '!']

	def initialize()
		@chromosome = ''
		for i in 0...13
			selection = Random.new.rand(@@possible_characters.size())
			@chromosome.concat(@@possible_characters[selection])
		end
		@fitness = 13
	end

	def compare(str)
		if str.length() != @chromosome.length()
			raise 'Strings Not Same Length Cannot Compare'
		end
		offcount = 0
		for i in 0...str.length()
			offcount += 1 if str[i] != @chromosome[i]
		end
		return offcount
	end

	def mate(other)
		crossPoint = Random.new.rand(@chromosome.length())
		results = [GeneticString.new(), GeneticString.new()]
		results[0].chromosome = @chromosome[0...crossPoint] + other.chromosome[crossPoint...other.chromosome.length()]
		results[1].chromosome = other.chromosome[0...crossPoint] + @chromosome[crossPoint...@chromosome.length()]
		return results
	end

	def mutate()
		character_selection = Random.new.rand(@@possible_characters.size())
		location_selection = Random.new.rand(@chromosome.length())
		@chromosome[location_selection] = @@possible_characters[character_selection]
	end
end

def evaluation(population)
	goal = 'Hello, World!'
	for i in 0...population.size()
		population[i].fitness = population[i].compare(goal)
	end
	return population
end

def runTest()
	options = default_GA_options()
	options[:debug] = true
	options[:greaterBetter] = false
	options[:genMax] = 10000
	options[:totalPopReplace] = true
	options[:selectionStyle] = 'best'
	pop = []
	for i in 0...100
		pop.push(GeneticString.new())
	end
	puts runGeneticAlgorithm(pop, method( :evaluation ), 0, options).chromosome
end

runTest()
