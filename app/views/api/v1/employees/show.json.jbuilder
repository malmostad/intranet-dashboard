json.catalog_id @employee.username
json.extract! @employee, :displayname, :first_name, :last_name, :title,
    :email, :phone, :cell_phone, :company, :department, :address, :room

json.roles @employee.roles.map(&:name)

json.avatars do |json|
  base_url = "//#{APP_CONFIG['avatar_base_url']}#{@employee.username}"
  json.xlarge           "#{base_url}/xlarge.jpg"
  json.large            "#{base_url}/large.jpg"
  json.large_quadrat    "#{base_url}/large_quadrat.jpg"
  json.medium           "#{base_url}/medium.jpg"
  json.medium_quadrat   "#{base_url}/medium_quadrat.jpg"
  json.small            "#{base_url}/small.jpg"
  json.small_quadrat    "#{base_url}/small_quadrat.jpg"
  json.thumb_quadrat    "#{base_url}/thumb_quadrat.jpg"
  json.tiny_quadrat     "#{base_url}/tiny_quadrat.jpg"
  json.mini_quadrat     "#{base_url}/mini_quadrat.jpg"
end
