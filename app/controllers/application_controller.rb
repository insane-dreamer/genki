class ApplicationController < ActionController::Base
#  include ExceptionNotifiable # using hoptoad

  helper :all # include all helpers, all the time

  # uses white_list and sanitize_params plugins to remove unsafe html tags from params
  before_filter :sanitize_params
  after_filter :set_content_type
  before_filter :session_sweep

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
#  protect_from_forgery :secret => 'a6a9e417376364b61645d469f04ac8cf'

  protected

  def set_content_type
    headers['Content-Type'] ||= 'application/xhtml+xml; charset=utf-8'
  end

  def config
    @@config = Enki::Config.default
  end
  helper_method :config

  def session_sweep
    # delete sessions that expired 30 minutes ago
    Session.sweep('30m')
  end

end
