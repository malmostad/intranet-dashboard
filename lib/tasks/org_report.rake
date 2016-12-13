namespace :org do
  desc "Update all user profiles from LDAP"
  task structure: :environment do
    axlsx = Axlsx::Package.new
    heading = axlsx.workbook.styles.add_style font_name: 'Calibri', bg_color: "000000", fg_color: "FFFFFF"
    body = axlsx.workbook.styles.add_style font_name: 'Calibri', fg_color: "000000"
    company_sheet = axlsx.workbook.add_worksheet(name: "company")
    company_sheet.add_row %w(company Employees Unique Managers), style: heading

    department_sheet = axlsx.workbook.add_worksheet(name: "department")
    department_sheet.add_row %w(company department Employees Unique Managers), style: heading

    division_sheet = axlsx.workbook.add_worksheet(name: "division")
    division_sheet.add_row %w(company department division Employees Unique Managers), style: heading

    house_identifier_sheet = axlsx.workbook.add_worksheet(name: "houseidentifier")
    house_identifier_sheet.add_row %w(company department division houseidentifier Employees Unique Managers), style: heading

    physical_delivery_office_name_sheet = axlsx.workbook.add_worksheet(name: "physicaldeliveryofficename")
    physical_delivery_office_name_sheet.add_row %w(company department division houseidentifier physicaldeliveryofficename Employees Unique Managers), style: heading

    User.select(:company).order(:company).uniq.map(&:company).each do |company|
      puts company
      users = User.where(company: company)
      company_sheet.add_row [company, users.size, users.map(&:manager_id).uniq.size], style: body
      User.where(company: company).select(:adm_department).order(:adm_department).uniq.map(&:adm_department).each do |adm_department|
        users = User.where(company: company, adm_department: adm_department)
        department_sheet.add_row [company, adm_department, users.size, users.map(&:manager_id).uniq.size], style: body
        User.where(company: company, adm_department: adm_department).select(:department).order(:department).uniq.map(&:department).each do |department|
          users = User.where(company: company, adm_department: adm_department, department: department)
          division_sheet.add_row [company, adm_department, department, users.size, users.map(&:manager_id).uniq.size], style: body
          User.where(company: company, adm_department: adm_department, department: department).select(:house_identifier).order(:house_identifier).uniq.map(&:house_identifier).each do |house_identifier|
            users = User.where(company: company, adm_department: adm_department, department: department, house_identifier: house_identifier)
            house_identifier_sheet.add_row [company, adm_department, department, house_identifier, users.size, users.map(&:manager_id).uniq.size], style: body
            User.where(company: company, adm_department: adm_department, department: department, house_identifier: house_identifier).select(:physical_delivery_office_name).order(:physical_delivery_office_name).uniq.map(&:physical_delivery_office_name).each do |physical_delivery_office_name|
              users = User.where(company: company, adm_department: adm_department, department: department, house_identifier: house_identifier, physical_delivery_office_name: physical_delivery_office_name)
              physical_delivery_office_name_sheet.add_row [company, adm_department, department, house_identifier, physical_delivery_office_name, users.size, users.map(&:manager_id).uniq.size], style: body
            end
          end
        end
      end
    end
    axlsx.serialize("reports/organisationsstruktur.xlsx")
  end
end
