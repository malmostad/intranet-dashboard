class AttachShortcutsToUser
  # Run once to attach the shortcuts users has through roles directly to user
  # https://github.com/malmostad/intranet-dashboard/issues/61
  def self.migrate
    User.find_each do |user|
      shortcuts = user.shortcuts
      user.roles.includes(:shortcuts).each do |role|
        shortcuts += role.shortcuts
      end
      user.shortcuts = shortcuts.uniq
      user.department_selected = true
      user.working_field_selected = true
      user.save(validate: false)
    end
  end
end
