class CreateCargoRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :cargo_requests do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :phone
      t.string :email
      t.integer :weight
      t.integer :length
      t.integer :width
      t.integer :height
      t.string :origin
      t.string :destination
      t.float :distance
      t.float :price

      t.timestamps
    end
  end
end
