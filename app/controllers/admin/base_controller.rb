class Admin::BaseController < ApplicationController
  respond_to :html

  layout 'admin'

  def current_ability
    @current_ability ||= Ability.new(current_user, 'admin')
  end

end
