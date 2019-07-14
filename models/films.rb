require_relative('../db/sql_runner.rb')

class Film

attr_reader :id
attr_accessor :title, :price

def initialize(options)
  @id = options['id'].to_i if options['id']
  @title = options['title']
  @price = options['price'].to_i
end

def save()
    sql = "INSERT INTO films
    (
      title,
      price
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@title, @price]
    films = SqlRunner.run( sql, values ).first
    @id = films['id'].to_i
  end

  def customers()
    sql = "SELECT customers.*
    FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    WHERE film_id = $1"
    values = [@id]
    customer_data = SqlRunner.run(sql, values)
    return Customer.map_items(customer_data)
  end

  def customer_count()
    return customers.count
  end

  # def tickets()
  #
  # end

  def update()
    sql = "
    UPDATE films SET (
      title,
      price
    ) =
    (
      $1, $2
    )
    WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
   sql = "DELETE FROM films"
   SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM films"
    film_data = SqlRunner.run(sql)
    result = film_data.map { |film| Film.new( film ) }
    return result
  end

  def self.map_items(film_data)
    result = film_data.map { |film| Film.new( film ) }
    return result
  end

end
