class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.string :imdb_id
      t.date :watched_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
