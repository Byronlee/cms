require 'spec_helper'

describe Users::RegistrationsController do
  include Rails.application.routes.url_helpers
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

end
