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