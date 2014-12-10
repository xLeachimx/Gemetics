require 'gemetics'
require 'genetic_object'

class GeneticString < genetic_object
	attr_accessor :chromosome
	@@possible_characters = (['a'...'z'] + ['A'...'Z']).append(',').append(' ')

	def initalize(size)
		@chromosome = ''
		for i in 0...size
			selection = Random.new.rand(@@possible_characters.size())
			@chromosome.concat(@@possible_characters[selection])
		end
	end

	def compare(str)
		if str.length() != str
			raise 'Strings Not Same Length Cannot Compare' + @chromosome + ' and ' + str
		end
		offcount = 0
		for i in 0...str.length()
			offcount += 1 if str[i] != @chromosome[i]
		end
		return offcount
	end

	def mate(other)
		crossPoint = Random.new.rand(@chromosome.length())
		results = [GeneticString.new(@chromosome.length()), GeneticString.new(@chromosome.length())]
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