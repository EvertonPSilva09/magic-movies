require 'sinatra'
require './app/lib/utils/dependencies'
require './app/business/cart'
require './app/models/movie'
require './app/models/user'
require './app/models/movie_reservation'

set :database, { adapter: 'sqlite3', database: 'magic-movies.sqlite3' }

users = User.new

def get_body(req)
  req.body.rewind
  JSON.parse(req.body.read)
end

get '/users' do
  users = User.all
  users.to_json
end

post '/users/register' do
  body = get_body(request)
  email = body['email']
  password = body['password']

  user = User.create(email: email, password: password)

  if user.valid?
    return { message: 'User registered successfully' }.to_json
  else
    status 400
    return { error: user.errors.full_messages.join(', ') }.to_json
  end
end
