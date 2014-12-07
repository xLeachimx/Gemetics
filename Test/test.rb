# Contains all testing materials

require 'gemetics'

class GeneticString < GeneticObject
	attr_accessor :chromosome

	def initialize()
		@chromosome = ''
		for i in 0...5
			possibles = ('a'..'z').to_a
			selection = Random.new.rand(possibles.size())
			@chromosome += possibles[selection]
		end
	end

	def mate(other)
    crossPoint = 0
		crossPoint = Random.new.rand(@chromosome.length()) while(crossPoint == 0)
		results = Array.new(2, "")
    results[0] = @chromosome[0..(crossPoint-1)] + other.chromosome[crossPoint...other.chromosome.length()]
    results[1] = other.chromosome[0..(crossPoint-1)] + @chromosome[crossPoint...@chromosome.length()]
    babys = Array.new(2, GeneticString.new())
    babys[0].chromosome = results[0]
    babys[1].chromosome = results[1]
		return babys
	end

	def mutate()
		possibles = ('a'..'z').to_a
		selection = possibles[Random.new.rand(possibles.size())]
		location = Random.new.rand(@chromosome.length())
		@chromosome[location] = selection
	end
end

def stringFitness(gs)
	offCount = 0
	correct = 'hello'
	for i in 0...correct.length()
		if gs.chromosome[i] != correct[i]
			offCount += 1
		end
	end
	return offCount
end

def evaluationPopulation(population)
  for i in 0...population.size()
    population[i].fitness = stringFitness(population[i])
  end
  return population
end

def runTest()
  options = default_GA_options
  options[:debug] = false
  options[:greaterBetter] = false
  options[:totalPopReplace] = true
  options[:mutation_percent] = 0.02
  options[:genMax] = 10000
  options[:selectionStlye] = 'best'
  options[:elitism] = 2
  initialPop = Array.new(100)
  for i in 0...initialPop.size()
    initialPop[i] = GeneticString.new()
  end
  runAlgorithm(initialPop, method(:evaluationPopulation), 0, options)
end

puts runTest().chromosome
