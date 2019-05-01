class RemoveAmountFromReceipts < ActiveRecord::Migration[5.2]
  def change
    remove_column :receipts, :amount, :decimal
  end
end
