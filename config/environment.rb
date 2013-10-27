# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Dashboard::Application.initialize!

# html5 is used in templates. This will autoclose empty tags.
Haml::Template.options[:format] = :xhtml

# Jbuilder.key_format camelize: :lower