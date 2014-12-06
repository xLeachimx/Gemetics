def default_GA_options()
  return {
	 greaterBetter: true,
	 totalPopReplace: true,
	 genMax: 1000,
	 selectionStyle: 'tournament',
	 mutation_percent: 0.05,
	 debug: false,
  }
end

def runAlgorithm(initialPopulation, eval, threshold, options)
  # make sure options is assigned
	if(options == nil)
		options = default_GA_options
	end
	currentGen = 0
	bestCanidate = initialPopulation[0]
	population = initialPopulation
	while(!exceedThreshold(options[:greaterBetter], bestCanidate.fitness, threshold) && currentGen < options[:genMax]) do
    if(options[:debug])
      puts bestCanidate.inspect
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
			reaplaced = []
			for i in 0...results.size()
				results[i].mutate() if Random.new.rand() < options[:mutation_percent]
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
				results = mates[0].mate(mates[1])
				for i in 0...results.size()
					results[i].mutate() if Random.new.rand() < options[:mutation_percent]
					newPopulation[have+i] = result[i] if (have+i) < needed
				end
				have += results.size()
			end
			population = newPopulation
		end
    currentGen += 1
	end
	return bestCanidate
end

def exceedThreshold(greaterBetter, val, threshold)
  if(val == nil)
    return false
  end
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