
require 'mysql2'

class Database
  def initialize(config = {})
    @connection = Mysql2::Client.new(config['database'])
    @connection.query_options.merge!(symbolize_keys: true)
  end

  def update_last_signin_for(username)
    @connection.query("update users set last_signin = '#{Time.now.utc}' where username = '#{username}'")
  end

  def user(username)
    @connection.query("select password_hash, last_signin from users where username = '#{username}'").to_a
  end
end
