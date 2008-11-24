# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'd76bfab6484e6b4abc452cd92dd122d1'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  private
  def verify_authenticity_token
    return true
  end
  def authenticate
    if user = authenticate_with_http_basic { |u, p| u if !u.to_s.strip.blank?  }
      logger.debug user
      @user = User.find_or_create_by_username(user)
    else
      request_http_basic_authentication
    end
  end
  
  private

  def render_tweets(root="statuses")
    respond_to do |format|
      format.html { render :template => 'statuses/tweets' }
      format.atom { render :template => 'statuses/tweets' }
      format.xml { render :xml => @tweets.map(&:to_map).to_xml(:root=>root, :skip_types=>true, :dasherize=>false).gsub('direct_messages','direct-messages') }
      format.json { render :json => @tweets.map(&:to_map) }
    end
  end

  def render_users(root="users")
    respond_to do |format|
      format.xml { render :xml => @users.map{|u| u.to_map(true)}.to_xml(:root=>root, :skip_types=>true, :dasherize=>false) }
      format.json { render :json => @users.map{|u| u.to_map(true) }}
    end
  end

  def render_tweet(root="status")
    respond_to do |format|
      format.html { render :action => 'tweet' }
      format.xml { render :xml => @tweet.to_xml(:root=>root, :skip_types=>true, :dasherize=>false) }
      format.json { render :json => @tweet.to_map }
    end
  end
  
end
