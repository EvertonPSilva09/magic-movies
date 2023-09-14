class CreateMovieReservations < ActiveRecord::Migration[6.1]
    def change
        create_table :movie_reservations do |t|
          t.integer :user_id, null: false
          t.integer :movie_id, null: false
          t.date :return_date, null: false
      
          t.timestamps
        end

        add_foreign_key :movie_reservations, :users, column: :id
        add_foreign_key :movie_reservations, :movies, column: :movie_id
      end
      end