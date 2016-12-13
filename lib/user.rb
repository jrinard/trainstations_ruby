require 'bcrypt'
require 'yaml'

class User
  include BCrypt
  attr_reader :name

  def self.authenticate(params = {})
    return nil if params[:username].blank? || params[:password].blank?

    @@credentials ||= YAML.load_file(File.join(__dir__, '../credentials.yml'))
    username = params[:username].downcase
    return nil if username != @@credentials['username']

    password_hash = Password.new(@@credentials['password_hash'])
    User.new(username) if password_hash == params[:password] # The password param gets hashed for us by the == method.
  end

  def initialize(username)
    @name = username.capitalize
  end
end
#
# require 'bcrypt'
#
# require_relative 'database'
#
#
# def user(username)
#   @connection.query("select password_hash, last_signin from users where username = '#{username}'").to_a
# end
#
# class User
#   include BCrypt
#   attr_reader :name
#   attr_reader :last_signin
#
#   def self.authenticate(config, params = {})
#     return nil if params[:username].blank? || params[:password].blank?
#
#     @@database ||= Database.new(config)
#     username = params[:username].downcase
#     user_record = @@database.user(username)
#     return nil if user_record.empty?
#
#     password_hash = Password.new(user_record.first[:password_hash])
#     last_signin = user_record.first[:last_signin]
#     User.new(username, last_signin) if password_hash == params[:password] # The password param gets hashed for us by ==
#   end
#
#   def initialize(username, last_signin)
#     @name = username.capitalize
#     @last_signin = last_signin.to_date_time
#     @@database.update_last_signin_for(username)
#   end
# end
