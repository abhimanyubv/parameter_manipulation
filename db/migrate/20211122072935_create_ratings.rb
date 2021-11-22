class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.float :score
      t.string :product
      t.string :username

      t.timestamps
    end
  end
end
