class CreateRuns < ActiveRecord::Migration[7.0]
  def change
    create_table :runs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shoe, null: false, foreign_key: true
      t.decimal :distance
      t.integer :duration
      t.integer :felt, default: 0
      t.text :notes
      t.date :date

      t.timestamps
    end
  end
end
