class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.bigint :movie_id
      t.string :title
      t.string :synopsis
      t.date :release_date
      t.string :poster_path

      t.timestamps
    end
  end
end
