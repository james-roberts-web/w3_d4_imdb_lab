require_relative ('../db/sql_runner.rb')

class Movie

  attr_reader :id
  attr_accessor :title, :genre, :budget

  def initialize(movie)
      @id = movie['id'].to_i if movie['id']
      @title = movie['title']
      @genre = movie['genre']
      @budget = movie['budget']
  end

  def save
    sql = "INSERT INTO movies (title, genre, budget)
    VALUES ($1, $2, $3) RETURNING id"
    values = [@title, @genre, @budget]
    movie = SqlRunner.run(sql, values).first
    @id = movie['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM movies"
    movies = SqlRunner.run(sql)
    result = movies.map { |movie| Movie.new(movie) }
    return result
  end

  def self.delete_all
    sql = "DELETE FROM movies"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE movies
    SET title = $1, genre = $2, budget = $3 WHERE id = $4"
    values = [@title, @genre, @budget, @id]
    SqlRunner.run(sql, values)
  end

  def read
    sql = "SELECT * FROM movies WHERE id = $1"
    values = [@id]
    hashes_arr = SqlRunner.run(sql, values)
    return hashes_arr.map{|movies|Movie.new(movies)}
  end

  def stars
    #movie1.stars
    #this would be to check what stars are in a particular movie
    sql = "SELECT stars.* FROM stars
    INNER JOIN castings
    ON castings.star_id = stars.id
    WHERE movie_id = $1"
    values = [@id]
    array = SqlRunner.run(sql, values)
    return array.map{|stars|Star.new(stars)}
  end

  def castings
    sql = "SELECT * FROM castings
          WHERE movie_id = $1"
    movie_value = [@id]
    array = SqlRunner.run(sql, movie_value)
    return array.map{|casting|Casting.new(casting)}
  end

  def remaining
    castings = self.castings
    fees = castings.map{|casting|casting.fee}
    total = fees.reduce(0){|total_fees, fee|total_fees += fee}
    return @budget -= total
  end

end
