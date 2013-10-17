json.key_format! camelize: :lower

json.array! @employees do |employee|
  json.catalog_id employee.username
  json.extract! employee, :id, :displayname, :first_name, :last_name, :title,
      :email, :phone, :cell_phone, :company, :department, :address, :room
end
