class MovieReservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  
  validates :user_id, presence: true
  validates :movie_id, presence: true
  validates :return_date, presence: true
end

  