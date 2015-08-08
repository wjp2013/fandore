class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :order, index: true
      t.references :variant, index: true
      t.integer :quantity, null: false
      t.decimal :price, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :adjustment_total, precision: 10, scale: 2, default: 0.0
      t.decimal :promo_total, precision: 10, scale: 2, default: 0.0

      # t.string  :currency
      # t.decimal :cost_price, precision: 10, scale: 2, default: 0.0, null: false
      # t.decimal :additional_tax_total, precision: 10, scale: 2, default: 0.0, null: false
      # t.decimal :included_tax_total, precision: 10, scale: 2, default: 0.0, null: false
      # t.decimal :pre_tax_amount, precision: 10, scale: 2, default: 0.0
      # t.integer :tax_category_id

      t.timestamps null: false
    end
  end
end
