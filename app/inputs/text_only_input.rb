class TextOnlyInput < SimpleForm::Inputs::Base
  def input
    "#{self.object.send(attribute_name.to_sym)}".html_safe
  end
end
