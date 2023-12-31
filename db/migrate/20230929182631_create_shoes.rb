class CreateShoes < ActiveRecord::Migration[7.0]
  def change
    create_table :shoes do |t|
      t.string :brand
      t.string :model
      t.decimal :mileage, default: 0
      t.integer :category, default: 0
      t.datetime :retired_on
      t.datetime :last_run_in
      t.integer :retire_at, default: 500

      t.timestamps
    end
  end
end
