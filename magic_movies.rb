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

get '/cart/list' do
  cart_items = cart.items

  if cart_items.empty?
    return { message: 'Cart is empty' }.to_json
  else
    cart_movies = cart_items.map do |movie|
      { id: movie.id, title: movie.title, synopsis: movie.synopsis }
    end

    return cart_movies.to_json
  end
end

post '/cart/add' do
  body = get_body(request)
  movie_id = body['movie_id']

  movie = Movie.find_by(id: movie_id)

  if movie
    cart.add_movie(movie)
    return { message: 'Movie added to cart' }.to_json
  else
    status 404
    return { error: 'Movie not found' }.to_json
  end
end

delete '/cart/remove' do
  body = get_body(request)
  movie_id = body['movie_id']

  movie = Movie.find_by(id: movie_id)

  if movie
    cart.remove_movie(movie)
    return { message: 'Movie removed from cart' }.to_json
  else
    status 404
    return { error: 'Movie not found' }.to_json
  end
end

delete '/cart/clear' do
  cart.clear
  return { message: 'Cart cleared' }.to_json
end

post '/cart/save' do
  body = get_body(request)
  user_id = body['user_id']
  cart_items = cart.items

  if cart_items.empty?
    return { error: 'Cart is empty' }.to_json
  end

  cart_items.each do |movie|
    MovieReservation.create(user_id: user_id, movie_id: movie.id, return_date: Date.today + 7)
  end

  cart.clear

  return { message: "Film reserved successfully, it will be available until the date #{Date.today + 7})" }.to_json
end
get '/movie_reservations' do
  movie_reservations = MovieReservation.all

  if movie_reservations.empty?
    return { message: 'No reservations found' }.to_json
  else

    reservation_info = movie_reservations.map do |reservation|
      {
        user_id: reservation.user_id,
        movie_id: reservation.movie_id,
        return_date: reservation.return_date
      }
    end

    return reservation_info.to_json
  end
end