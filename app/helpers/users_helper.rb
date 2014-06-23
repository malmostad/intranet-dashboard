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

  def skill_link_list(skills)
    skills.map do |skill|
      link_to skill.name, users_tags_path(skill: skill.name)
    end.join(", ")
  end

  def activity_link_list(activities)
    activities.map do |activity|
      link_to activity.name, users_tags_path(activity: activity.name)
    end.join(", ")
  end

  def language_link_list(languages)
    languages.map do |language|
      link_to language.name, users_tags_path(language: language.name)
    end.to_sentence.humanize
  end
end
