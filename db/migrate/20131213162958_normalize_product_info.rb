class NormalizeProductInfo < ActiveRecord::Migration
  def up
    add_column :sales, :product_id, :integer
    Sale.reset_column_information
    Sale.find_each do |sale|
      product = Product.find_or_create_by(name: sale.product_name)
      sale.product = product
      sale.save
    end
    remove_column :sales, :product_name
  end

  def down
    add_column :sales, :product_name, :string
    Sale.find_each do |sale|
      sale.product_name = sale.product.name
      sale.save
    end
    remove_column :sales, :product_id
    Product.delete_all
  end
end
