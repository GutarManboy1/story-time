class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def after_sign_up_path_for(resource)
    root_path
  end
end
