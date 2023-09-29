class AddColorToShoes < ActiveRecord::Migration[7.0]
  def change
    add_column :shoes, :color, :string
  end
end
