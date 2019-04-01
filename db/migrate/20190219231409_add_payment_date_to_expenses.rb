class AddPaymentDateToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :paymentdate, :date
  end
end
