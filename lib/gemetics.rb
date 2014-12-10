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
  }
end

def runGeneticAlgorithm(initialPopulation, eval, threshold, options)
  # make sure options is assigned
	if(options == nil)
		options = default_GA_options
	end
	validOptions(options,population.size()) # Raises error if options are not correct
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
			if(options[:debug])
				puts "Selected individuals:"
				puts mates[0].inspect
				puts mates[1].inspect
			end

			# mate and replace
			results = mateOrgs(mates[0], mates[1])
			replaced = []
			if(options[:elitism] > 0)
				population = sortedPopulation
				for i in 0...options[:elitism]
				  replaced.append(0)
				end
			end
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
			if(option[:elitism] > 0)
				for i in 0...options[:elitism]
				  newPopulation[i] = sortedPopulation[i]
				end
			end
			while have < needed do
				mates = selection(sortedPopulation.clone(), options[:selectionStyle])

				if(options[:debug])
					puts "Selected individuals:"
					puts mates[0].inspect
					puts mates[1].inspect
				end

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
	subPop = population[0...10]
	additiveFitness = 0
	result = []
	for member in subPop
		additiveFitness += member.fitness
	end
	selection = Random.new.rand()
	for member in subPop
		selection -= (member.fitness/additiveFitness)
		if(selection < 0) result.append(member)
	end
	selection = Random.new.rand()
	for member in subPop
		selection -= (member.fitness/additiveFitness)
		if(selection < 0) result.append(member)
	end
	result.append(subPop.pop())while result.size() < 2
	return result
end

def bestSelection(population)
	return population[0..1]
end

def mateOrgs(one, two)
	return one.mate(two)
end

# Validation

def validOptions(options, populationSize)
	raise 'Required Option Missing' if !hasRequiredOptions(options)
	raise 'Options Not Within Limits' if !withinLimits(options, populationSize)
	return true
end

def hasRequiredOptions(options)
	return false if !options.has_key?(:greaterBetter)
	return false if !options.has_key?(:totalPopReplace)
	return false if !options.has_key?(:genMax)
	return false if !options.has_key?(:mutation_percent)
	return false if !options.has_key?(:debug)
	return false if !options.has_key?(:elitism)
	return true
end

def withinLimits(options, populationSize)
	possibleGreaterBetter = [true, false]
	possibleTotalPopReplace = [true, false]
	possibleDebug = [true, false]
	possibleSelectionStyle = ['tournament', 'best']
	return false if !(possibleGreaterBetter.include?(options[:greaterBetter]))
	return false if !(possibleTotalPopReplace.include?(options[:totalPopReplace]))
	return false if !(options[:genMax]>0)
	return false if !(possibleSelectionStyle.include?(options[:selectionStyle]))
	return false if !(options[:mutationPercent]>0.0)
	return false if !(possibleDebug.include?(options[:debug]))
	return false if !(options[:elitism]>=0 && options[:elitism]<populationSize)
	return true
end