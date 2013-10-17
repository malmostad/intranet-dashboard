json.array! @group_contacts do |group_contact|
  json.extract! group_contact, :id, :name
end
