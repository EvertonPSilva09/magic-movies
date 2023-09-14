class Movie < ActiveRecord::Base
  validates :title, presence: true
  validates :synopsis, presence: true
  validates :release_date, presence: true
  
  has_many :movie_reservations
end
