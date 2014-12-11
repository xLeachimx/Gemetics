require_relative 'genetic_object'

def default_GA_options()
  return {
	greaterBetter: true,
	totalPopReplace: true,
	genMax: 1000,
	selectionStyle: 'tournament',
	mutationPercent: 0.05,
	elitism: 0,
	debug: false,
	tournamentSize: 10,
  }
end

def runGeneticAlgorithm(initialPopulation, eval, threshold, options)
	# make sure options is assigned
	if(options == nil)
		options = default_GA_options()
	end
	validOptions(options,initialPopulation.size()) # Raises error if options are not correct
	currentGen = 0
	bestCanidate = initialPopulation[0]
	population = initialPopulation
	while(continue?(bestCanidate.fitness, threshold, currentGen, options)) do
		# evaluate the population
		population = eval.call(population)

	    if(options[:greaterBetter])
			sortedPopulation = population.sort{ |x , y| y.fitness <=> x.fitness }
		else
			sortedPopulation = population.sort{ |x , y| x.fitness <=> y.fitness }
		end
		bestCanidate = population[0].clone

		if(options[:debug])
	    	puts 'Best Canidate Soultion:'
	     	puts bestCanidate.inspect
        	puts 'Current Generation:'
	     	puts currentGen
	     	puts 'Average Fitness:'
	     	cumulative = 0
	     	for org in population
	     		cumulative += org.fitness
	     	end
	     	puts cumulative/population.size()
	    end


		if(options[:totalPopReplace] == false)
			# Do not replace every organism
			mates = selection(sortedPopulation.clone(), options)

			# mate and replace
			results = mateOrgs(mates[0], mates[1])
			replaced = []
			if(options[:elitism] > 0)
				population = sortedPopulation
				for i in 0...options[:elitism]
				  replaced.append(i)
				end
			end
			for i in 0...results.size()
				results[i].mutate() if Random.new.rand() < options[:mutationPercent]
				temp = Random.new.rand(population.size())
				while(replaced.include?(temp)) do
					temp = Random.new.rand(population.size())
				end
				replaced.push(temp)
				population[replaced[-1]] = results[i]
			end
		else
			# Repalce every single organism
			needed = population.size()
			have = 0
			newPopulation = Array.new(population.size(), GeneticObject.new)
			if(options[:elitism] > 0)
				for i in 0...options[:elitism]
				  newPopulation[i] = sortedPopulation[i]
				end
			end
			while have < needed do
				mates = selection(sortedPopulation.clone(), options)

				# mate and put them into new pop
				results = mateOrgs(mates[0], mates[1])
				for i in 0...results.size()
					results[i].mutate() if Random.new.rand() < options[:mutationPercent]
					newPopulation[have+i] = results[i] if (have+i) < needed
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
	return false if currentGen > options[:genMax]
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

def selection(population, options)
	# select mates
	if(options[:selectionStyle] == 'tournament')
		return tournamentSelection(population, options[:tournamentSize])
	elsif(options[:selectionStyle] == 'best')
		return bestSelection(population)
	elsif(options[:selectionStyle] == 'roulette')
		return rouletteSelection(population)
	end
	raise 'Problem with selection type'
end

# Selection algorithms are based on population being sorted

def tournamentSelection(population, size)
	population = population.shuffle
	subPop = population[0...size]
	additiveFitness = 0
	result = []
	for member in subPop
		additiveFitness += member.fitness
	end
	for member in subPop
		if Random.new.rand() <= (member.fitness/additiveFitness)
			result.push(member)
			break
		end
	end
	for member in subPop
		if Random.new.rand() <= (member.fitness/additiveFitness)
			result.push(member)
			break
		end
	end
	result.push(subPop[0]) while result.size() < 2
	return result
end

def bestSelection(population)
	return population[0..1]
end

def rouletteSelection(population)
	additiveFitness = 0.0
	for member in population
		additiveFitness += member.fitness
	end

	result = []
	for member in population
		if Random.new.rand() <= (member.fitness/additiveFitness)
			result.push(member)
			break
		end
	end
	
	for member in population
		if Random.new.rand() <= (member.fitness/additiveFitness)
			result.push(member)
			break
		end
	end

	result.push(population[0]) while result.size() < 2
	return result
end

def mateOrgs(one, two)
	return one.mate(two)
end

# Validation

def validOptions(options, populationSize)
	raise 'Required Option Missing' if !hasRequiredOptions(options)
	raise 'Required Dependent Options Missing' if !hasRequiredDependentOptions(options)
	raise 'Options Not Within Limits' if !withinLimits(options, populationSize)
	raise 'Dependent Options Not Within Limits' if !dependentOptionsWithinLimits(options, populationSize)
	return true
end

def hasRequiredOptions(options)
	return false if !options.has_key?(:greaterBetter)
	return false if !options.has_key?(:totalPopReplace)
	return false if !options.has_key?(:selectionStyle)
	return false if !options.has_key?(:genMax)
	return false if !options.has_key?(:mutationPercent)
	return false if !options.has_key?(:debug)
	return false if !options.has_key?(:elitism)
	return true
end

def hasRequiredDependentOptions(options)
	if(options[:selectionStyle] == 'tournament')
		return false if !options.has_key?(:tournamentSize)
	end
	return true
end

def withinLimits(options, populationSize)
	possibleGreaterBetter = [true, false]
	possibleTotalPopReplace = [true, false]
	possibleDebug = [true, false]
	possibleSelectionStyle = ['tournament', 'best', 'roulette']
	return false if !(possibleGreaterBetter.include?(options[:greaterBetter]))
	return false if !(possibleTotalPopReplace.include?(options[:totalPopReplace]))
	return false if !(options[:genMax]>0)
	return false if !(possibleSelectionStyle.include?(options[:selectionStyle]))
	return false if !(options[:mutationPercent]>0.0)
	return false if !(possibleDebug.include?(options[:debug]))
	return false if !(options[:elitism]>=0 && options[:elitism]<populationSize)
	return true
end

def dependentOptionsWithinLimits(options, populationSize)
	if(options[:selectionStyle] == 'tournament')
		return false if !(options[:tournamentSize] > 0 && options[:tournamentSize] <= populationSize)
	end
	return true
end