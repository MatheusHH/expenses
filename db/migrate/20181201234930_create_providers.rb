class CreateProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :cnpj
      t.string :phone

      t.timestamps
    end
  end
end
