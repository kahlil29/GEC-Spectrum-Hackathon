class PriceHistory < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :site_name
      t.string :product_name
      t.integer :product_cost
      
    end
  end
end
