class ApplicationController < ActionController::Base
  include ExceptionNotification::Notifiable

  helper :all # include all helpers, all the time

  after_filter :set_content_type

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :only => [:update, :destroy] # :secret => 'a6a9e417376364b61645d469f04ac8cf'


  def log(*entries)
    # used to preceed logger output to make it easier to find
    logger.info "\e[1;32m LOGGER OUTPUT: #{Time.now} \e[0m"
    entries.each { |e| logger.info "\e[1;31m #{e}\e[0m" } 
    logger.info "\e[1;32m --- END --- \e[0m"
  end

  protected

  def set_content_type
    headers['Content-Type'] ||= 'application/xhtml+xml; charset=utf-8'
  end

  def config
    @@config = Enki::Config.default
  end
  helper_method :config

end
