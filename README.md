Gemetics
========
A Ruby gem which simplifies the process of making genetic algorithms

========
Installation
========
```
gem install gemetics
```
========
Including in project
========
```ruby
require 'gemetics'
```
========
Before Using
========
First you need to create a custom subclass of the GeneticObject class

```ruby
class MyGeneticObject < GeneticObject
	def mate(other)
		...
	end

	def mutate()
		...
	end
end
``` 

The subclass must replace the methods mate and mutation in the GeneticObject class

You will also need to define an evaluation method which takes in a population of you custom GeneticObjects
and returns a population where each individual objects fitness is set

It would be in the interest of one using this would want to make sure all settings are to their liking.

These are the default settings(default are used if the options argument is nil)

```ruby
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
```
=======
Use
=======
To run a genetic algorithm call this function

```ruby
def runAlgorithm(initialPopulation, eval, threshold, options)
	...
end
```
Returns the best canidate solution when done

Where
* intialPopulation is a random population of your custom subclass
* eval is your custom evaluation method
* threshold is the desired minimum value of fitness to be considered passing
* options is the options you wish to run the GA with(nil resorts to default)

=======
Options
=======
|Option             |Default     |Purpose                                                                 |
|:-----------------:|:----------:|:-----------------------------------------------------------------------|
|greaterBetter      |true        |Determines if greater fitness values are better                         |
|totalPopReplace    |true        |Determines if population should be completly replace between generations|
|genMax             |1000        |Maximum generations allowed                                             |
|selectionStyle     |'tournament'|Determines selection type                                               |
|mutation_percent   |0.05        |Determines percentage of offspring that are mutated                     |
|debug              |false       |If true will output debug info                                          |
|elitism            |0           |Determines the number of perserved top canidate solutions               |

|Option             |Values(Possible)              |
|:-----------------:|:----------------------------:|
|greaterBetter      |true/false                    |
|totalPopReplace    |true/false                    |
|genMax             |integer > 0                   |
|selectionStyle     |'tournament'/'best'           |
|mutation_percent   |float >= 0                    |
|debug              |true/false                    |
|elitism            |0 <= integer < population.size|