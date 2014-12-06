default_GA_ptions = {
	:greaterBetter = true
	:totalPopReplace = true
	:genMax = 1000
	:selectionStyle = 'tournament'
	:mutation_percent = .05
}


def runAlgorithm(initialPopulation, eval, threshold, options)
	if(options == nil)
		options = default_GA_options
	end
	currentGen = 0
	bestCanidate = nil
	population = initialPopulation
	while(bestCanidate.fitness != threshold && currentGen < options[:genMax]) do
		for i in population
			eval.call(population)
		end
		population = population.sort{ |x,y| x.fitness <=> y.fitness}
		bestCanidate = population[0].clone
		if(options[:selectionStyle] == 'tournament'){
			mates = tournamentSelection(population)
		}
	end
end

def tournamentSelection(population)
end

def bestSelection(population)
end

class GeneticObject
	attr_accessor :fitness

	def initialize()
	end

	def mutate()
		raise 'Method Not Implemented'
	end

	def mate(other)
		raise 'Meothd Not Implemented'
	end
end