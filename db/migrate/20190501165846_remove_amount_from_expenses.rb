class RemoveAmountFromExpenses < ActiveRecord::Migration[5.2]
  def change
    remove_column :expenses, :amount, :decimal
  end
end
