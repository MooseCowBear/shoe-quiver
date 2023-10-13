class AddUnitToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :unit, :integer, default: 0
  end
end
