json.array! @employees do |employee|
  json.catalog_id employee.username
  json.extract! employee, :id, :first_name, :last_name, :title,
      :email, :company, :department
end
