require_relative('models/movie')
require_relative('models/star')
require_relative('models/casting')

require('pry')

movie1 = Movie.new({'title' => 'Lord of The Rings', 'genre' => 'Fantasy', 'budget' => 2000000})
movie1.save

movie2 = Movie.new({'title' => 'The Avengers', 'genre' => 'Action', 'budget' => 1000000})
movie2.save

star1 = Star.new({'first_name' => 'Ian', 'last_name' => 'McKellan'})
star1.save

star2 = Star.new({'first_name' => 'Joanna', 'last_name' => 'Lumley'})
star2.save

star3 = Star.new({'first_name' => 'Patrick', 'last_name' => 'Macnee'})
star3.save

casting1 = Casting.new({'movie_id' => movie1.id, 'star_id' => star1.id, 'fee' => 500000})
casting1.save

casting2 = Casting.new({'movie_id' => movie2.id, 'star_id' => star2.id, 'fee' => 300000})
casting2.save

casting3 = Casting.new({'movie_id' => movie2.id, 'star_id' => star3.id, 'fee' => 100000})
casting3.save

binding.pry
