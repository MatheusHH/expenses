class AddAmountToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :amount_cents, :integer
  end
end
