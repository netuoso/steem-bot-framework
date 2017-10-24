class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper

  protect_from_forgery with: :exception

  before_action :set_body_class
  before_action :set_paper_trail_whodunnit

  private

  def set_body_class
    @body_class = "#{controller_name}-#{action_name}"
  end

end
