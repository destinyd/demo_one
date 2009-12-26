class DdchatsController < ApplicationController
  before_filter :with_user
  def index
    #    debugger
      return @ddchats = Ddchat.all(
        :conditions => ["created_at > ?",Time.parse(cookies[:since_timestamp]).utc],
        :order => "created_at desc"
      ) if params[:first] && cookies[:since_timestamp]
    
    if session[:chat_time] >= 3.seconds.ago
      session[:chat_time] = Time.now
      render :text => ""
      return
    end unless session[:chat_time].blank?
    session[:chat_time] ||= Time.now
    @ddchats = Ddchat.all(
      :conditions => ["created_at > ?",session[:chat_time].utc],
      :order => "created_at desc"
    )
    session[:chat_time]=Time.now unless @ddchats.blank?

    render :text => "" if @ddchats.blank?

  end
  
  def create
    if session[:chat_time] >= 3.seconds.ago
      render 'ddchats/fail.rjs'
      return
    end if session[:chat_time]
    
    session[:chat_time] ||= Time.now
    @ddchat = Ddchat.new(params[:ddchat])
    @ddchat.name=current_player.name
    tmp=Ddchat.find(:first,:conditions => {:name => @ddchat.name,:body => @ddchat.body})
    return render 'ddchats/fail.rjs' if tmp
    @ddchat.save
    @ddchats = Ddchat.all(
      :conditions => ["created_at > ?", session[:chat_time].utc],#session[:chat_time]],
      :order => "created_at desc"
    )
    @ddchats << @ddchat if !@ddchat.id.nil? && @ddchats.blank?
    cookies[:since_timestamp]=Time.now if !@ddchat.id.nil? && cookies[:since_timestamp].blank?
    session[:chat_time]=Time.now unless @ddchats.blank?
    Ddchat.destroy_all(['created_at < ?',10.minutes.ago])
  end

end
