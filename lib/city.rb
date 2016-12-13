
class City
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id, nil)
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO city (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch("id").to_i()
  end

  define_singleton_method(:all) do
    results = DB.exec("SELECT * FROM city;")
    citys = []
    results.each() do |result|
      id = result.fetch("id").to_i
      name = result.fetch("name")
      citys.push(City.new({:name => name, :id => id}))
    end
    citys
  end

  define_method(:==) do |other_city|
    self.name().==(other_city.name()).&(self.id().==(other_city.id()))
  end

  define_singleton_method(:find) do |id|
    cities = City.all()
    found_city = nil
    cities.each() do |city|
      if city.id == id
        found_city = city
      end
    end
    found_city
  end


  define_method(:delete) do
    DB.exec("DELETE FROM city WHERE id = #{self.id()};")
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name)
    @id = self.id()
    DB.exec("UPDATE city SET name = '#{@name}' WHERE id = #{@id};")
  end

# It will add a train with a stop time to the city in the train_city database
  define_method(:add_train) do |attributes|
    train_id = attributes.fetch(:train_id, nil)
    stop_time = attributes.fetch(:stop_time, '00:00:00')
    price = attributes.fetch(:price, '0')
    DB.exec("INSERT INTO train_city (train_id, city_id, stop_time, price) VALUES (#{train_id}, #{self.id()}, '#{stop_time}', '#{price}');")
  end
# return a list of trains of the city
  define_method(:trains) do
    city_trains = []
    results = DB.exec("SELECT train_id FROM train_city WHERE city_id = #{self.id()};")
    p results.to_a
    results.each() do |result|
      train_id = result.fetch('train_id').to_i()
      train = DB.exec("SELECT * FROM train WHERE id = #{train_id}")
      route = train.first().fetch('route')
      city_trains.push(Train.new({:route => route, :id => train_id}))
    end
    city_trains
  end

  define_method(:find_time) do |train_id|
    result = DB.exec("SELECT * FROM train_city WHERE city_id =#{self.id} AND train_id =#{train_id}")
    result.first().fetch('stop_time').to_s
  end
  define_method(:find_price) do |train_id|
    result = DB.exec("SELECT * FROM train_city WHERE city_id =#{self.id} AND train_id =#{train_id}")
    result.first().fetch('price').to_s
  end

end
