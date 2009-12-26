# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '453c52d6bb22c86480351790d918ddf0'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  include AuthenticatedSystem

  def current_player
    session[:player_id] ? @current_player ||=
      Player.find(session[:player_id]) : nil
  end

  def current_adventurer
    session[:adventurer_id] ? @current_adventurer ||= Adventurer.find(session[:adventurer_id]) : nil
  end

  def with_user
    @user = current_user
    unless @user
      flash[:notice]="请先登陆"
      redirect_to login_path
      return false
    end
  end

  def with_player
    @player ||= current_player
  end
  
  def with_player_item
    @player_item = @player.player_items.find(params[:id])
  end

  def index_by_flash(message)
    flash[:notice]=message
    redirect_to :action => :index
  end

  def login_session(player)
    session[:player_id] = player.id
    session[:plugin_ids] = 
      player.plugin_ids.blank? ? nil : player.plugin_ids
    session[:player_name] = player.name
  end

end
