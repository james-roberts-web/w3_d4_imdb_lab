require_relative('../db/sql_runner.rb')

class Casting

  attr_reader :id
  attr_accessor :movie_id, :star_id, :fee

  def initialize(casting)
      @id = casting['id'].to_i if casting['id']
      @movie_id = casting['movie_id'].to_i
      @star_id = casting['star_id'].to_i
      @fee = casting['fee'].to_i
  end

  def save
    sql = "INSERT INTO castings (movie_id, star_id, fee)
    VALUES ($1, $2, $3) RETURNING id"
    values = [@movie_id, @star_id, @fee]
    casting = SqlRunner.run(sql, values).first
    @id = casting['id'].to_i
  end

  def self.all
    sql = "SELECT * FROM castings"
    castings = SqlRunner.run(sql)
    result = castings.map { |casting| Casting.new(castings) }
    return result
  end

  def self.delete_all
    sql = "DELETE FROM castings"
    SqlRunner.run(sql)
  end

  def update
    sql = "UPDATE castings SET fee = $1 WHERE id = $2"
    values = [@fee, @id]
    SqlRunner.run(sql, values)
  end

  def movie
    sql = "SELECT * FROM movies WHERE id = $1"
    values = [@movie_id]
    movie = SqlRunner.run(sql, values).first
    return Movie.new(movie)
  end

  def star
    sql = "SELECT * FROM stars WHERE id = $1"
    values = [@star_id]
    star = SqlRunner.run(sql, values).first
    return Star.new(star)
  end

end
