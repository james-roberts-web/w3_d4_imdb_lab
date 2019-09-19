require_relative ('../db/sql_runner.rb')

class Movie

  attr_reader :id
  attr_accessor :title, :genre

  def initialize(movie)
      @id = movie['id'].to_i if movie['id']
      @title = movie['title']
      @genre = movie['genre']
  end

  def save
    sql = "INSERT INTO movies (title, genre)
    VALUES ($1, $2) RETURNING id"
    values = [@title, @genre]
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
    SET title = $1, genre = $2 WHERE id = $3"
    values = [@title, @genre, @id]
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

end
