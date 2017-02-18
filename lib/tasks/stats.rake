namespace :stats do
  task all_users_roles: :environment do
    file = File.open('log/all_users_roles.xls', 'w')
    roles = Role.all

    file.write "Username\tCompany\t#{roles.map(&:name).join("\t")}\tChanged shortcuts\n"
    User.includes(:roles).find_each do |user|
      row = "#{user.username}\t#{user.company}\t"
      roles.each do |role|
        row += "#{user.roles.include?(role)}\t"
        # row += "#{user.changed_shortcuts}"
      end
      file.write "#{row}\n"
    end
    file.close
  end

  task roles: :environment do
    roles = {}
    [:total, :department, :working_field].each { |category| roles[category] = {} }

    User.all.each do |user|
      [:total, :department, :working_field].each do |category|
        if category == :total
          n = user.roles.count
        else
          n = user.roles.where(category: category).count
        end
        if roles[category][n].nil?
          roles[category][n] = 0
        end
        roles[category][n] += 1
      end
    end
    [:total, :department, :working_field].each do |category|
      puts category.to_s.titlecase
      roles[category].sort.each do |key, val|
        puts "  #{key}: #{val}"
        # puts "  #{Hash[roles[category].sort]}"
      end
    end
  end

  task departments: :environment do
    file = File.open("log/departments.csv", 'w')
    Role.where(category: "department").each do |role|
      multiple_roles = 0
      role.users.each do |user|
        multiple_roles += 1 if user.roles.where(category: "department").count > 1
      end
      file.write "#{role.name}\t#{role.users.count}\t#{multiple_roles}\n"
    end
    file.close
  end
end
