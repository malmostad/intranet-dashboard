module UsersHelper
  def admin_or_myself?
    current_user.id == @user.id || current_user.admin?
  end
end
