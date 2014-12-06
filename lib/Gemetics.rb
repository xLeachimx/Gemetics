default_GA_options = {
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
	while(!exceedThreshold(options[:greaterBetter], bestCanidate.fitness, threshold) && currentGen < options[:genMax]) do

		# evaluate the population
		eval.call(population)
		if(options[:greaterBetter])
			sortedPopulation = population.sort{ |x , y| y.fitness <=> x.fitness }
		else
			sortedPopulation = population.sort{ |x , y| x.fitness <=> y.fitness }
		end
		bestCanidate = population[0].clone


		if(options[:totalPopReplace] == false)
			# Do not replace every organism
			selection(sortedPopulation.clone(), options[:selectionStyle])

			# mate and replace
			results = mates[0].mate(mates[1])
			replace = Array.new(2, Random.new.rand(population.size()))
			# don't replace same org
			replace[1] = Random.new.rand(population.size())while(replace[1] == replace[0])
			population[replace[0]] = results[0]
			population[replace[1]] = results[1]
		else
			# Repalce every single organism
			needed = population.size()
			have = 0
			newPopulation = Array.new(population.size(), GeneticObject.new)
			while have < needed do
				selection(sortedPopulation.clone(), options[:selectionStyle])

				# mate and put them into new pop
				results = mates[0].mate(mates[1])
				results[0].mutate() if Random.new.rand() < options[:mutation_percent]
				results[1].mutate() if Random.new.rand() < options[:mutation_percent]
				newPopulation[have] = results[0]
				newPopulation[have+1] = results[1] if (have+1) < needed
			end
			population = newPopulation
		end
	end
	return bestCanidate
end

def exceedThreshold(greaterBetter, val, threshold)
	if(greaterBetter)
		return val>=threshold
	else
		return val<=threshold
	end
end

def selection(population, type)
	# select mates
	if(type == 'tournament')
		return tournamentSelection(population)
	else
		return bestSelection(population)
	end
end

def tournamentSelection(population)
	population = population.shuffle
	return population[0..10].sort{ |x , y| x.fitness <=> y.fitness }[0..1]
end

def bestSelection(population)
	return population[0..1]
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