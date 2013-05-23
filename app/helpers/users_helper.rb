module UsersHelper
  def admin_or_myself?
    current_user.id == @user.id || current_user.admin?
  end

  def company_short(user)
    user.company.gsub(/^[\d\s]*/, "") if user.company.present?
  end
end
