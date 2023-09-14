require 'sinatra'
require './app/lib/utils/dependencies'
require './app/business/cart'
require './app/models/movie'
require './app/models/user'
require './app/models/movie_reservation'

set :database, { adapter: 'sqlite3', database: 'magic-movies.sqlite3' }
