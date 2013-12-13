class NormalizeCustomerInfo < ActiveRecord::Migration
  def up
    add_column :sales, :customer_id, :integer
    Sale.reset_column_information
    Sale.find_each do |sale|
      new_customer_name = format_customer(sale.attributes["customer_and_account_no"])
      customer = Customer.find_or_create_by(name: new_customer_name[0], account_no: new_customer_name[1])
      sale.customer_id = customer.id
      sale.save
    end
    remove_column :sales, :customer_and_account_no
  end

  def down
    add_column :sales, :customer_and_account_no
    Sale.find_each do |sale|
      sale.attributes["customer_and_account_no"] = "#{sale.customer.name} #{sale.customer.account_no}"
      sale.save
    end
    Customer.delete_all
  end

  def format_customer(customer)
    customer.gsub(/[()]/, "").split(' ')
  end
end
