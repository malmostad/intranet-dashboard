desc "Migrate group contacts from MalmoAut export"
task migrate_group_contacts: :environment do

  # Group contacts in use
  contact_boxes = File.open(Rails.root.join('migrate', 'contact_boxes.csv'), 'r').each_line.map do |line|
    line.split(";").first
  end

  # All group contacts
  File.open( Rails.root.join('migrate', 'group_contacts.csv'), 'r').each_line do |line|
    group_contact = line.split(";")
    if contact_boxes.include? group_contact[2]
      GroupContact.create(
        name: group_contact[2],  # cn
        email: group_contact[4],  # MalmoKonEpost
        phone: group_contact[5],  # MalmoKonTelefonnr
        fax: group_contact[11], # MalmoKonFaxNr
        phone_hours: group_contact[10], # MalmoKonTeletid
        homepage: group_contact[1],  # MalmoKonHemsida
        address: group_contact[3],  # MalmoKonPostadr
        zip_code: group_contact[7],  # MalmoKonPostnr
#        postal_town:
        visitors_address: group_contact[6],  # MalmoKonBesokadr
        visitors_address_zip_code: group_contact[12], # MalmoKonBesokpostnr
#        visitors_address_postal_town:
        visiting_hours: group_contact[8],  # MalmoKonBesoktid
        legacy_dn: group_contact[0]  # dn
      )
    end
  end
end
