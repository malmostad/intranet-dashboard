module SimpleForm
  module Inputs

    # Return the attribute as a string
    class TextOnlyInput < Base
      def input(wrapper_options)
        self.object.send(attribute_name.to_sym).to_s
      end
    end

    # Return the attribute as a string + an <a> tag used by javascript to show more info
    class MoreInfoInput < TextOnlyInput
      def input(wrapper_options)
        super + template.content_tag(:a, " (info)", href: "#", class: "show-more-info")
      end
    end
  end
end
