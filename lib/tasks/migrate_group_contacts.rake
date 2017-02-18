# A run once task
desc "Migrate group contacts from MalmoAut export"
task migrate_group_contacts: :environment do

  # Group contacts in use
  contact_boxes = File.open(Rails.root.join('import', 'contact_boxes.csv'), 'r').each_line.map do |line|
    line.split(";").first
  end

  # All group contacts
  migrated = 0
  not_in_use = 0
  not_cn = 0
  duplicates = 0
  File.open( Rails.root.join('import', 'group_contacts.csv'), 'r').each_line do |line|
    group_contact = line.split(";")
    if !contact_boxes.include? group_contact[2]
      not_in_use += 1
      puts "Not in use: #{group_contact.first}"
    elsif group_contact[2].empty?
      not_cn += 1
      puts "No cn for: #{group_contact.first}"
    elsif GroupContact.where(name: group_contact[2]).present?
      duplicates += 1
      puts "Duplicate: #{group_contact.first}"
    else
      migrated += 1
      GroupContact.create(
        name: group_contact[2].strip,          # cn
        email: group_contact[4].strip,         # MalmoKonEpost
        phone: group_contact[5].strip,         # MalmoKonTelefonnr
        fax: group_contact[11].strip,          # MalmoKonFaxNr
        phone_hours: group_contact[10].strip,  # MalmoKonTeletid
        homepage: group_contact[1].strip,      # MalmoKonHemsida
        address: group_contact[3].strip,       # MalmoKonPostadr
        zip_code: group_contact[7].strip,      # MalmoKonPostnr
#        postal_town:
        visitors_address: group_contact[6].strip,           # MalmoKonBesokadr
        visitors_address_zip_code: group_contact[12].strip, # MalmoKonBesokpostnr
#        visitors_address_postal_town:
        visiting_hours: group_contact[8].strip,             # MalmoKonBesoktid
        legacy_dn: group_contact[0].strip                   # dn
      )
    end
  end
  puts "Migrated: #{migrated}"
  puts "Not in use: #{not_in_use}"
  puts "No cn: #{not_cn}"
  puts "Duplicates: #{duplicates}"
end
