class TextOnlyInput < SimpleForm::Inputs::Base
  # Return the attribute as a string
  def input
    self.object.send(attribute_name.to_sym).to_s
  end
end
