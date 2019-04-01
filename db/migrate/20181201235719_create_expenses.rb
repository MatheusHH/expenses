class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.references :provider, foreign_key: true
      t.references :category, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
