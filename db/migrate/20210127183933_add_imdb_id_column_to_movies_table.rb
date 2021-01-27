class AddImdbIdColumnToMoviesTable < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :imdb_id, :string
    add_column :movies, :user_id, :integer
    change_column :movies, :rating, :float   
  end
end
