class HomepageController < ApplicationController
  before_filter :authorize,:except =>:index
  def index
    render :layout => false
  end
  def show
    unless session[:player_id].nil?
      redirect_to(:controller => :players,:action => :new)
      return
    end
  end
end
