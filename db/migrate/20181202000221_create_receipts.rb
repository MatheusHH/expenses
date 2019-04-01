class CreateReceipts < ActiveRecord::Migration[5.2]
  def change
    create_table :receipts do |t|
      t.references :description, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
