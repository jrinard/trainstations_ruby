require('rspec')
require('city')
require('train')
require('pg')


DB = PG.connect({:dbname => 'trainstations_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM train *;")
    DB.exec("DELETE FROM city *;")
  end
end
