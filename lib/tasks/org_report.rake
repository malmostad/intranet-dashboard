namespace :org do
  desc "Update all user profiles from LDAP"
  task report: :environment do
    File.open("log/org_structure.log", 'w') do |file|
      companies = User.select(:company).order(:company).uniq.map(&:company)
      file.puts "COMPANY (#{companies.size})"

      companies.each do |company|
        file.puts "#{company}"

        adm_departments = User.where(company: company).select(:adm_department).order(:adm_department).uniq.map(&:adm_department)
        file.puts "--ADM_DEPARTMENT/DEPARTMENT (#{adm_departments.size})"

        adm_departments.each do |adm_department|
          file.puts "  #{adm_department}"

          departments = User.where(company: company, adm_department: adm_department).select(:department).order(:department).uniq.map(&:department)
          file.puts "----DEPARTMENT/DIVISION (#{departments.size})"
          departments.each do |department|
            file.puts "    #{department}"

            house_identifiers = User.where(company: company, adm_department: adm_department, department: department).select(:house_identifier).order(:house_identifier).uniq.map(&:house_identifier)
            file.puts "------HOUSE_IDENTIFIER (#{house_identifiers.size})"
            house_identifiers.each do |house_identifier|
              file.puts "      #{house_identifier}"

              physical_delivery_office_names = User.where(company: company, adm_department: adm_department, department: department, house_identifier: house_identifier).select(:physical_delivery_office_name).order(:physical_delivery_office_name).uniq.map(&:physical_delivery_office_name)
              file.puts "--------PHYSICAL_DELIVERY_OFFICE_NAME (#{physical_delivery_office_names.size})"
              physical_delivery_office_names.each do |physical_delivery_office_name|
                file.puts "        #{physical_delivery_office_name}"
              end
            end
          end
        end
      end
    end
  end
end
