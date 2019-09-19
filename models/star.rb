require_relative ('../db/sql_runner.rb')

class Star

  attr_reader :id
  attr_accessor :first_name, :last_name

  def initialize(star)
      @id = star['id'].to_i if star['id']
      @first_name = star['first_name']
      @last_name = star['last_name']
  end

  def save
    sql = "INSERT INTO stars (first_name, last_name)
    VALUES ($1, $2) RETURNING id"
    values = [@first_name, @last_name]
    star = SqlRunner.run(sql, values).first
    @id = star['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM stars"
    stars = SqlRunner.run(sql)
    result = stars.map { |star| Star.new(star) }
    return result
  end

  def self.delete_all
    sql = "DELETE FROM stars"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE stars
    SET first_name = $1, last_name = $2 WHERE id = $3"
    values = [@first_name, @last_name, @id]
    SqlRunner.run(sql, values)
  end

  def read
    sql = "SELECT * FROM stars WHERE id = $1"
    values = [@id]
    hashes_arr = SqlRunner.run(sql, values)
    return hashes_arr.map{|star|Star.new(star)}
  end

  def movies
    sql = "SELECT movies.* FROM movies
    INNER JOIN castings
    ON castings.movie_id = movies.id
    WHERE star_id = $1"
    values = [@id]
    array = SqlRunner.run(sql, values)
    return array.map{|stars|Movie.new(stars)}


  end

end
