class AddAmountToReceipts < ActiveRecord::Migration[5.2]
  def change
    add_column :receipts, :amount_cents, :integer
  end
end
