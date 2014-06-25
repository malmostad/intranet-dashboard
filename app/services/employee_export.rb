class EmployeeExport
  def self.to_vcard(user, root_url)
    vcard = VCardigan.create(version: "4.0")
    vcard.uid "malmo-stad-#{user.username}"
    vcard.name user.last_name, user.first_name, charset: "utf-8"
    vcard.fullname user.displayname, charset: "utf-8"
    vcard.org "Malmö stad;#{user.company_short};#{user.department}", type: "WORK", charset: "utf-8"
    vcard.title user.title, type: "WORK", charset: "utf-8"
    vcard.adr ";;#{user.address};#{user.postal_town};;#{user.post_code};", type: "WORK", charset: "utf-8", label: "\"#{user.address}\\n#{user.post_code} #{user.postal_town}\""
    vcard.add "TEL;TYPE=WORK", user.phone
    vcard.add "TEL;TYPE=CELL", user.cell_phone
    vcard.email user.email, type: "INTERNET"
    vcard.url "#{root_url}users/#{user.username}", type: "WORK"
    vcard.add "X-SOCIALPROFILE;TYPE=Twitter", user.twitter
    vcard.add "IMPP;X-SERVICE-TYPE=Skype", "skype:#{user.skype}"
    begin
      vcard.photo Base64.strict_encode64(File.open(user.avatar.path(:large_quadrat)).read), type: "JPEG", encoding: "BASE64"
    rescue;end
    vcard.rev user.updated_at.iso8601
    vcard.to_s
  end

  def self.group_as_xlsx(users)
    axlsx = Axlsx::Package.new
    heading = axlsx.workbook.styles.add_style font_name: 'Calibri', bg_color: "000000"
    body = axlsx.workbook.styles.add_style font_name: 'Calibri', fg_color: "000000"
    axlsx.workbook.add_worksheet do |sheet|
      sheet.add_row %w(
        Namn
        Adress
        Postnummer
        Postort
        E-postadress
        Telefon
        Mobiltelefon
      ), style: heading
      users.each do |user|
        user_addr = [
          user.displayname,
          user.address,
          user.post_code,
          user.postal_town,
          user.email,
          user.phone,
          user.cell_phone
        ]
        sheet.add_row user_addr, style: body
      end
    end
    axlsx.to_stream.read
  end

  def self.filename(params)
    "#{params.except(:controller, :action, :format).map {|k,v| v }.join(" ")} #{Date.today.iso8601}"
  end
end
