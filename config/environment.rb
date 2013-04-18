# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
DashboardKomin::Application.initialize!

# html5 is used in templates. This will autoclose empty tags.
Haml::Template.options[:format] = :xhtml