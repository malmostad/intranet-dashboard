json.catalog_id @employee.username
json.extract! @employee, :id, :first_name, :last_name, :title,
    :email, :phone, :cell_phone, :company, :department, :address, :room

json.roles @employee.roles.map(&:name)

# json.avatars do |avatar|
#   base_url = "//#{APP_CONFIG['avatar_base_url']}#{@employee.username}"
#   avatar.xlarge           "#{base_url}/xlarge.jpg"
#   avatar.large            "#{base_url}/large.jpg"
#   avatar.large_quadrat    "#{base_url}/large_quadrat.jpg"
#   avatar.medium           "#{base_url}/medium.jpg"
#   avatar.medium_quadrat   "#{base_url}/medium_quadrat.jpg"
#   avatar.small            "#{base_url}/small.jpg"
#   avatar.small_quadrat    "#{base_url}/small_quadrat.jpg"
#   avatar.thumb_quadrat    "#{base_url}/thumb_quadrat.jpg"
#   avatar.tiny_quadrat     "#{base_url}/tiny_quadrat.jpg"
#   avatar.mini_quadrat     "#{base_url}/mini_quadrat.jpg"
# end
