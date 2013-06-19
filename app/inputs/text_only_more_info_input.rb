class TextOnlyMoreInfoInput < SimpleForm::Inputs::TextOnlyInput
  # Return the attribute as a string + an <a> tag used by javascript to show more info
  def input
    super + template.content_tag(:a, "(info)", href: "#", class: "show-more-info")
  end
end
