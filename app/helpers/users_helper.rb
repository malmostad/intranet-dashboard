module UsersHelper
  def myself?
    current_user.id == @user.id
  end

  def admin_or_myself?
    current_user.id == @user.id || current_user.admin?
  end

  def load_more_query
    { page: params[:page].to_i + 1 }.merge(params.except(:controller, :action, :page))
  end

  def has_news?
    @combined_entries.present? || @news_entries.present?
  end
end
