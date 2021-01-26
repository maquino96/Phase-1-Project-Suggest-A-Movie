class CreateQustionnairesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :questionnaires do |t|
      t.string :name
      t.string :user_id
      t.string :q1
      t.string :q1answer
      t.string :q2
      t.string :q2answer
      t.timestamps 
    end
  end
end
