module UsersHelper
  def myself?
    current_user.id == @user.id
  end

  def admin_or_myself?
    current_user.id == @user.id || current_user.admin?
  end

  def load_more_query
    { term: params[:term],
      company: params[:company],
      department: params[:department],
      page: @offset / @limit + 1 }
  end

  def skill_link_list(skills)
    skills.map do |skill|
      link_to skill.name, users_path(skill: skill.name)
    end.join(", ")
  end

  def language_link_list(languages)
    languages.map do |language|
      link_to language.name, users_path(language: language.name)
    end.to_sentence.humanize
  end
end
