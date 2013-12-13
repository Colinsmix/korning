class NormalizeEmployeeInfo < ActiveRecord::Migration
  def up
    add_column :sales, :employee_id, :integer
    Sale.find_each do |sale|
      new_employee_name = format_employee(sale.employee)
      employee = Employee.find_or_create_by(email: new_employee_name[2])
      employee.name = "#{new_employee_name[0]} #{new_employee_name[1]}"
      sale.employee = employee
      sale.save
    end
    remove_column :sales, :employee
  end

  def down
    add_column :sales, :employee, :string
    Sale.find_each do |sale|
      sale.employee = "#{sale.employee.name} #{sale.employee.email}"
      sale.save
    end
    remove_column :sales, :employee_id
    Employee.delete_all
  end

  def format_employee(employee)
    employee.gsub(/[()]/, "")
    employee.split(' ')
  end

end
