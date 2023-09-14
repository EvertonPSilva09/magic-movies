require 'sinatra'
require './app/lib/utils/dependencies'
require './app/business/cart'
require './app/models/movie'
require './app/models/user'
require './app/models/movie_reservation'

set :database, { adapter: 'sqlite3', database: 'magic-movies.sqlite3' }

users = User.new
movies = Movie.new

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
get '/' do
  movies = Movie.all
  movies.to_json
end

get '/movies' do
  movies = Movie.all
  movies.to_json
end

get '/movies/:id' do
  id = params['id'].to_i
  movie = Movie.find_by(id: id)

  if movie
    movie.to_json
  else
    status 404
    body 'Movie not found'
  end
end

get '/movies/title/:title' do
  title = params['title']
  movie = Movie.find_by(title: title)

  if movie
    movie.to_json
  else
    status 404
    body 'Movie not found'
  end
end

post '/movies' do
  body = get_body(request)
  movie = Movie.create(movie_id: body['movie_id'], title: body['title'], synopsis: body['synopsis'], release_date: body['release_date'], poster_path: body['poster_path'])

  if movie.valid?
    movie.to_json
  else
    status 400
    body movie.errors.full_messages.to_json
  end
end

put '/movies/:id' do
  id = params['id'].to_i
  body = get_body(request)
  movie = Movie.find_by(id: id)

  if movie
    movie.update(movie_id: body['movie_id'], title: body['title'] || movie.title,
                 synopsis: body['synopsis'] || movie.synopsis,
                 release_date: body['release_date'] || movie.release_date,
                 poster_path: body['poster_path'] || movie.poster_path)

    if movie.valid?
      movie.to_json
    else
      status 400
      body movie.errors.full_messages.to_json
    end
  else
    status 404
    body 'Movie not found'
  end
end


delete '/movies/:id' do
  id = params['id'].to_i
  movie = Movie.find_by(id: id)

  if movie
    movie.destroy
    movie.to_json
  else
    status 404
    body 'Movie not found'
  end
end

