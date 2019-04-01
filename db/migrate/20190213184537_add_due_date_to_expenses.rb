class AddDueDateToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :duedate, :date
  end
end
