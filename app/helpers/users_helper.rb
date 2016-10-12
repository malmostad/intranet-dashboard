module UsersHelper
  def myself?
    current_user.id == @user.id
  end

  def admin_or_myself?
    current_user.id == @user.id || current_user.admin?
  end

  def admin_or_contacts_editor_or_myself?
    current_user.id == @user.id || current_user.admin? || current_user.contacts_editor?
  end

  def has_news?
    @combined_entries.present? || @news_entries.present?
  end
end
