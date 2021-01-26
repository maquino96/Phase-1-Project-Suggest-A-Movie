class CreateGenresTable < ActiveRecord::Migration[5.2]
  def change
    create_table :genres do |t|
      t.string :questionnaire_id
      t.string :movie_id
      t.string :name
    end
  end
end
