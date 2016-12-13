require("spec_helper")


describe(City) do
  describe('#initialize') do
    it "check initial parameters" do
      test_city = City.new({:name => "Portland"})
      expect(test_city.name()).to(eq("Portland"))
    end
  end
  describe('#save') do
    it "save it to database" do
      test_city = City.new({:name => "Portland"})
      test_city.save()
      expect(City.all()).to(eq([test_city]))
    end
  end
  describe('.all') do
    it "select all citys from database" do
      test_city1 = City.new({:name => "Portland"})
      test_city1.save()
      test_city2 = City.new({:name => "Vancouver"})
      test_city2.save()
      expect(City.all()).to(eq([test_city1, test_city2]))
    end
  end

  describe('#==') do
    it "overides equals" do
      test_city1 = City.new({:name => "Portland"})
      test_city2 = City.new({:name => "Portland"})
      expect(test_city1).to(eq(test_city2))
    end
  end

  describe("#delete") do
    it "deletes city from database" do
      test_city2 = City.new({:name => "Vancouver"})
      test_city2.save()
      test_city2.delete()
      expect(City.all()).to(eq([]))
    end
  end

  describe("#update") do
    it "lets you update city in the database" do
      test_city = City.new({:name => "Vancouver"})
      test_city.save()
      test_city.update({:name => "Portland"})
      expect(test_city.name).to(eq("Portland"))
    end

    it "lets you add a train to the city" do
      test_city = City.new({:name => "Vancouver"})
      test_city.save()
      test_train = Train.new({:route => "green"})
      test_train.save()
      test_city.add_train({:train_id => test_train.id(), :stop_time => '09:00:00'})
      expect(test_city.trains()).to(eq([test_train]))
    end
  end




end
