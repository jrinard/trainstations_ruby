require("spec_helper")


describe(Train) do
  describe('#initialize') do
    it "check initial parameters" do
      test_train = Train.new({:route => "green"})
      expect(test_train.route()).to(eq("green"))
    end
  end
  describe('#save') do
    it "save it to database" do
      test_train = Train.new({:route => "green"})
      test_train.save()
      expect(Train.all()).to(eq([test_train]))
    end
  end
  describe('.all') do
    it "select all trains from database" do
      test_train1 = Train.new({:route => "green"})
      test_train1.save()
      test_train2 = Train.new({:route => "blue"})
      test_train2.save()
      expect(Train.all()).to(eq([test_train1, test_train2]))
    end
  end

  describe('#==') do
    it "overides equals" do
      test_train1 = Train.new({:route => "green"})
      test_train2 = Train.new({:route => "green"})
      expect(test_train1).to(eq(test_train2))
    end
  end

  describe("#delete") do
    it "deletes train from database" do
      test_train2 = Train.new({:route => "blue"})
      test_train2.save()
      test_train2.delete()
      expect(Train.all()).to(eq([]))
    end
  end

  describe("#update") do
    it "lets you update train in the database" do
      test_train = Train.new({:route => "blue"})
      test_train.save()
      test_train.update({:route => "green"})
      expect(test_train.route).to(eq("green"))
    end
    it "lets you add a city to the train" do
      test_city = City.new({:name => "Vancouver", :id => nil})
      test_city.save()
      test_train = Train.new({:route => "green"})
      test_train.save()
      test_train.add_city(test_city.id(), '09:00:00')
      expect(test_train.cities()).to(eq([test_city]))
    end
  end

  describe(".find") do
    it "find a train based on id" do
      test_train = Train.new({:route => "blue"})
      test_train.save()

      expect(Train.find(test_train.id)).to(eq(test_train))
    end
  end




end
