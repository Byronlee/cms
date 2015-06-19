# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActsAsTaggableOn.force_lowercase = true
ActsAsTaggableOn.strict_case_match = true