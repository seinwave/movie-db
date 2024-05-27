class AddScoreToRatings < ActiveRecord::Migration[7.0]
  def change
     add_column :ratings, :score, :integer
  end
end
