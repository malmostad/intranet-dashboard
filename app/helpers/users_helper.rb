module UsersHelper
  def admin_or_myself?
    current_user.id == @user.id || current_user.admin?
  end

  def load_more_query
    { term: params[:term],
      company: params[:company],
      department: params[:department],
      page: @offset / @limit + 1 }
  end
end
