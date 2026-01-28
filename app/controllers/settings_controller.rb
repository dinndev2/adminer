class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_accessible?
  
  def general

  end
end
