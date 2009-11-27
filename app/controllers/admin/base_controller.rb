class Admin::BaseController < ApplicationController
  layout 'admin'

  before_filter :require_login
  before_filter :session_sweep

  protected

  def require_login
    return redirect_to(admin_session_path) unless session[:logged_in]
  end

  def set_content_type
    headers['Content-Type'] ||= 'text/html; charset=utf-8'
  end

  def session_sweep
    # delete sessions that expired 30 minutes ago
    Session.sweep('30m')
  end

end
