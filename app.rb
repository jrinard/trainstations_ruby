require("sinatra")
require("sinatra/reloader")
require('./lib/city')
require('./lib/train')
also_reload("./lib/**/*.rb")
require('pg')
require 'sinatra/flash'

require_relative 'lib/core_ext/object'
require_relative 'lib/authentication'
require_relative 'lib/user'

TEN_MINUTES   = 60 * 10
use Rack::Session::Pool, expire_after: TEN_MINUTES # Expire sessions after ten minutes of inactivity
helpers Authentication


DB = PG.connect({:dbname => 'trainstations_test'})

helpers do
  def redirect_to_original_request
    user = session[:user]
    flash[:notice] = "Welcome back #{user.name}."
    original_request = session[:original_request]
    session[:original_request] = nil
    redirect original_request
  end
end

get '/signin/?' do
  erb :signin, locals: { title: 'Sign In' }
end

post '/signin/?' do
  if user = User.authenticate(params)
    session[:user] = user
    redirect_to_original_request
  else
    flash[:notice] = 'You could not be signed in. Did you enter the correct username and password?'
    redirect '/signin'
  end
end

get '/signout' do
  session[:user] = nil
  flash[:notice] = 'You have been signed out.'
  redirect '/'
end

get '/?' do
  erb :index, locals: { title: 'Home' }
end

get '/protected/?' do
  authenticate!
  erb :protected, locals: { title: 'Protected Page' }
end

get('/') do
  erb(:index)
end

get('/admin') do
  authenticate!
  @trains = Train.all()
  @cities = City.all()
  erb(:admin)
end

get('/train_new') do
  authenticate!
  erb(:train_form)
end

post('/trains') do
  route = params.fetch('route')
  Train.new({:route => route}).save()
  @trains = Train.all()
  @cities = City.all()
  erb(:admin)
end

get('/admin/train/:id') do
  authenticate!
  id = params.fetch('id').to_i
  @train = Train.find(id)
  @cities = City.all()
  @train_cities = @train.cities()
  erb(:train)
end

get('/city_new')do
  authenticate!
  erb(:city_form)
end

post('/cities') do
  name = params.fetch('name')
  City.new({:name => name}).save()
  @cities = City.all()
  @trains = Train.all()
  erb(:admin)
end

get('/admin/city/:id')do
  authenticate!
  id = params.fetch('id').to_i
  @city = City.find(id)
  @city_trains = @city.trains()
  @trains = Train.all()
  erb(:city)
end

delete("/admin/train/:id") do
  @train = Train.find(params.fetch("id").to_i)
  @train.delete()
  @trains = Train.all()
  @cities = City.all()
  erb(:admin)
end

get("/admin/train/:id/edit") do
  authenticate!
  @train = Train.find(params.fetch("id").to_i)
  erb(:train_edit)
end

patch('/admin/train/:id')do
  route = params.fetch("route")
  @train = Train.find(params.fetch("id").to_i)
  @train.update({:route => route})
  @cities = City.all()
  @train_cities = @train.cities()
  erb(:train)
end

delete("/admin/city/:id") do
  @city = City.find(params.fetch("id").to_i)
  @city.delete()
  @trains = Train.all()
  @cities = City.all()
  @city_trains = @city.trains()
  erb(:admin)
end

get("/admin/city/:id/edit") do
  authenticate!
  @city = City.find(params.fetch("id").to_i)
  erb(:city_edit)
end

patch('/admin/city/:id')do
  name = params.fetch("name")
  @city = City.find(params.fetch("id").to_i)
  @city.update({:name => name})
  @city_trains = @city.trains()
  @trains = Train.all()

  erb(:city)
end


post('/admin/trains/:id') do
  train_id = params.fetch('id').to_i
  city_id = params.fetch('city_id').to_i
  @city = City.find(city_id)
  @train = Train.find(train_id)
  stop_time = params.fetch('stop_time').to_s
  price = params.fetch('price').to_s
  @train.add_city({:city_id => city_id, :stop_time => params.fetch('stop_time').to_s, :price => price})
  @trains = Train.all()
  @cities = City.all()
  @train_cities = @train.cities()
  erb(:train)
end

post('/admin/cities/:id') do
  city_id = params.fetch('id').to_i
  train_id = params.fetch('train_id').to_i
  @city = City.find(city_id)
  @train = Train.find(train_id)
  stop_time = params.fetch('stop_time').to_s
  price = params.fetch('price').to_s
  @city.add_train({:train_id => train_id, :stop_time => stop_time, :price => price})
  @trains = Train.all()
  @cities = City.all()
  @city_trains = @city.trains()
  @train_cities = @train.cities()
  erb(:city)
end


# Customers!

get('/customers/trains') do
  @trains = Train.all()
  @cities = City.all()
  erb(:customer_trains)
end
get('/customers/cities') do
  @trains = Train.all()
  @cities = City.all()
  erb(:customer_cities)
end

get('/customer/train/:id') do
  id = params.fetch('id').to_i
  @train = Train.find(id)
  @cities = City.all()
  @train_cities = @train.cities()
  erb(:customer_train)
end

get('/customer/city/:id')do
  id = params.fetch('id').to_i
  @city = City.find(id)
  @city_trains = @city.trains()
  @trains = Train.all()
  erb(:customer_city)
end

get('/buy_ticket/:id') do
  @price = params.fetch('id').to_i
  erb(:buy_ticket)
end

post('/buy_ticket/:id') do
  @price = params.fetch('id').to_i
  erb(:buy_ticket)
end
