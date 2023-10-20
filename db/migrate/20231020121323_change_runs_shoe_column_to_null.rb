class ChangeRunsShoeColumnToNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :runs, :shoe_id, true
  end
end
