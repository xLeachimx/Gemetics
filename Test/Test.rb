require 'lib/Gemetics'

class GeneticString < GeneticObject
	attr_accessor :chromosome

	def initialize():
		@chromosome = ""
		for i in 0...5
			possibles = ('a'..'z').to_a
			selection = Random.new.rand(possibles.size())
			@chromosome.concat(possibles[selection])
		end
	end

	def intialize(str):
		@chromosome = str
	end

	def mate(other):
		crossPoint = Random.new.rand(@chromosome.length())
		results = Array.new(2, "")
		for i in 0...crossPoint
			results[0].concat(@chromosome[i])
			results[1].concat(other.chromosome[i])
		end
		return results
	end

	def mutate():
		possibles = ('a'..'z').to_a
		selection = Random.new.rand(possibles.size())
		location = Random.new.rand(@chromosome.length())
		@chromosome[location] = selection
	end
end

def stringFitness(gs):
	offCount = 0
	correct = "hello"
	for i in 0...correct.size()
		if gs[i] != correct[i]
			offCount += 1
		end
	end
	return offCount
end