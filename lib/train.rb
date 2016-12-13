class Train
  attr_reader(:route, :id)

  define_method(:initialize) do |attributes|
    @route = attributes.fetch(:route)
    @id = attributes.fetch(:id, nil)
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO train (route) VALUES ('#{@route}') RETURNING id;")
    @id = result.first.fetch("id").to_i()
  end

  define_singleton_method(:all) do
    results = DB.exec("SELECT * FROM train;")
    trains = []
    results.each() do |result|
      id = result.fetch("id").to_i
      route = result.fetch("route")
      trains.push(Train.new({:route => route, :id => id}))
    end
    trains
  end

  define_method(:==) do |other_train|
    self.route().==(other_train.route()).&(self.id().==(other_train.id()))
  end

  define_method(:delete) do
    DB.exec("DELETE FROM train WHERE id = #{self.id()};")
  end

  define_method(:update) do |attributes|
    @route = attributes.fetch(:route)
    @id = self.id()
    DB.exec("UPDATE train SET route = '#{@route}' WHERE id = #{@id};")
  end

  define_singleton_method(:find) do |id|
    trains = Train.all()
    found_train = nil
    trains.each() do |train|
      if train.id == id
        found_train = train
    end
  end
  found_train
end


# It will add a train with a stop time to the city in the train_city database
  define_method(:add_city) do |attributes|
    city_id = attributes.fetch(:city_id, nil)
    stop_time = attributes.fetch(:stop_time, '00:00:00')
    price = attributes.fetch(:price, '0')
    DB.exec("INSERT INTO train_city (train_id, city_id, stop_time, price) VALUES (#{self.id}, #{city_id}, '#{stop_time}', '#{price}');")
  end
# return a list of trains of the city
  define_method(:cities) do
    train_cities = []
    results = DB.exec("SELECT city_id FROM train_city WHERE train_id = #{self.id()};")
    results.each() do |result|
      city_id = result.fetch('city_id').to_i()
      city = DB.exec("SELECT * FROM city WHERE id = #{city_id}")
      name = city.first().fetch('name')
      train_cities.push(City.new({:name => name, :id => city_id}))
    end
    train_cities
  end
  define_method(:find_time) do |city_id|
    result = DB.exec("SELECT * FROM train_city WHERE city_id =#{city_id} AND train_id =#{self.id}")
    result.first().fetch('stop_time').to_s
  end
  define_method(:find_price) do |city_id|
    result = DB.exec("SELECT * FROM train_city WHERE city_id =#{city_id} AND train_id =#{self.id}")
    result.first().fetch('price').to_s
  end

end
