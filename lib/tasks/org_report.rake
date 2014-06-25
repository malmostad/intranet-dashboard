namespace :org do
  desc "Update all user profiles from LDAP"
  task report: :environment do
    axlsx = Axlsx::Package.new
    heading = axlsx.workbook.styles.add_style font_name: 'Calibri', bg_color: "000000", fg_color: "FFFFFF"
    body = axlsx.workbook.styles.add_style font_name: 'Calibri', fg_color: "000000"
    axlsx.workbook.add_worksheet(name: "Organisationsstruktur") do |sheet|
      sheet.add_row %w(company adm_department department house_identifier physical_delivery_office_name), style: heading
      sheet.add_row %w(company department division houseIdentifier physicalDeliveryOfficeName), style: heading

      User.select(:company).order(:company).uniq.map(&:company).each do |company|
        User.where(company: company).select(:adm_department).order(:adm_department).uniq.map(&:adm_department).each do |adm_department|
          User.where(company: company, adm_department: adm_department).select(:department).order(:department).uniq.map(&:department).each do |department|
            User.where(company: company, adm_department: adm_department, department: department).select(:house_identifier).order(:house_identifier).uniq.map(&:house_identifier).each do |house_identifier|
              User.where(company: company, adm_department: adm_department, department: department, house_identifier: house_identifier).select(:physical_delivery_office_name).order(:physical_delivery_office_name).uniq.map(&:physical_delivery_office_name).each do |physical_delivery_office_name|
                sheet.add_row [company, adm_department, department, house_identifier, physical_delivery_office_name], style: body
              end
            end
          end
        end
      end
      sheet.add_row ["Rapport genererad #{Time.now.localtime.to_s[0..18]}"], style: body
      end
    axlsx.serialize("reports/organisationsstruktur.xlsx")
  end
end
