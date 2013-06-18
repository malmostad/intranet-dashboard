class TextOnlyMoreInfoInput < SimpleForm::Inputs::TextOnlyInput
  def input
    super + template.content_tag(:a, "(info)", href: "#", class: "show-more-info")
  end
end
