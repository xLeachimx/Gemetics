def default_GA_options()
  return {
	 greaterBetter: true,
	 totalPopReplace: true,
	 genMax: 1000,
	 selectionStyle: 'tournament',
	 mutationPercent: 0.05,
	 debug: false,
  }
end

def runGeneticAlgorithm(initialPopulation, eval, threshold, options)
  # make sure options is assigned
	if(options == nil)
		options = default_GA_options
	end
	validOptions(options) # Raises error if options are not correct
	currentGen = 0
	bestCanidate = initialPopulation[0]
	population = initialPopulation
	while(continue?(bestCanidate.fitness, threshold, currentGen, options)) do
	    if(options[:debug])
	    	puts 'Best Canidate Soultion:'
	      puts bestCanidate.inspect
        puts 'Current Generation:'
	      puts currentGen
	    end
		# evaluate the population
		population = eval.call(population)
		if(options[:greaterBetter])
			sortedPopulation = population.sort{ |x , y| y.fitness <=> x.fitness }
		else
			sortedPopulation = population.sort{ |x , y| x.fitness <=> y.fitness }
		end
		bestCanidate = population[0].clone


		if(options[:totalPopReplace] == false)
			# Do not replace every organism
			mates = selection(sortedPopulation.clone(), options[:selectionStyle])

			# mate and replace
			results = mateOrgs(mates[0], mates[1])
			replaced = []
			for i in 0...results.size()
				results[i].mutate() if Random.new.rand() < options[:mutationPercent]
				temp = Random.new.rand(population.size())
				while(!replaced.includes?(temp)) do
					temp = Random.new.rand(population.size())
				end
				replaced.append(temp)
				population[replaced[-1]] = results[i]
			end
		else
			# Repalce every single organism
			needed = population.size()
			have = 0
			newPopulation = Array.new(population.size(), GeneticObject.new)
			while have < needed do
				mates = selection(sortedPopulation.clone(), options[:selectionStyle])

				# mate and put them into new pop
				results = mateOrgs(mates[0], mates[1])
				for i in 0...results.size()
					results[i].mutate() if Random.new.rand() < options[:mutationPercent]
					newPopulation[have+i] = result[i] if (have+i) < needed
				end
				have += results.size()
			end
			population = newPopulation
		end
    # Increment generations
    currentGen += 1
	end
	return bestCanidate
end

# Internal Logic

def continue?(highestFitness, threshold, currentGen, options)
	return false if exceedsThreshold?(options[:greaterBetter], highestFitness, threshold)
	return false if currentGen > options[:maxGen]
	return true
end

def exceedsThreshold?(greaterBetter, val, threshold)
	if(val == nil)
	return false
	end
	if(greaterBetter)
		return val>=threshold
	else
		return val<=threshold
	end
	return false
end

def selection(population, type)
	# select mates
	if(type == 'tournament')
		return tournamentSelection(population)
	elsif(type == 'best')
		return bestSelection(population)
	end
	raise 'Problem with selection type'
end

def tournamentSelection(population)
	population = population.shuffle
	return population[0..10].sort{ |x , y| x.fitness <=> y.fitness }[0..1]
end

def bestSelection(population)
	return population[0..1]
end

def mateOrgs(one, two)
	return one.mate(two)
end

# Validation

def validOptions(options)
	raise 'Required Option Missing' if !hasRequiredOptions(options)
	raise 'Options Not Within Limits' if !withinLimits(options)
	return true
end

def hasRequiredOptions(options)
	return false if !options.has_key?(:greaterBetter)
	return false if !options.has_key?(:totalPopReplace)
	return false if !options.has_key?(:genMax)
	return false if !options.has_key?(:mutation_percent)
	return false if !options.has_key?(:debug)
	return true
end

def withinLimits(options)
	possibleGreaterBetter = [true, false]
	possibleTotalPopReplace = [true, false]
	possibleDebug = [true, false]
	possibleSelectionStyle = ['tournament', 'best']
	return false if !(possibleGreaterBetter.includes?(options[:greaterBetter]))
	return false if !(possibleTotalPopReplace.includes?(options[:totalPopReplace]))
	return false if !(options[:genMax]>0)
	return false if !(possibleSelectionStyle.includes?(options[:selectionStyle]))
	return false if !(options[:mutationPercent]>0.0)
	return false if !(possibleDebug.includes?(options[:debug]))
	return true
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