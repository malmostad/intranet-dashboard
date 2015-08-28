class AttachShortcutsToUser
  # Run once to attach the shortcuts users has through roles directly to user
  # https://github.com/malmostad/intranet-dashboard/issues/61
  def self.migrate
    User.all.each do |user|
      user.roles.each do |role|
        role.shortcuts.each do |shortcut|
          unless user.shortcuts.include? shortcut
            user.shortcuts << shortcut
          end
        end
      end
    end
  end
end
