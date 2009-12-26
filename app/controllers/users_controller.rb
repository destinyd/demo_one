class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  

  # render new.rhtml
  def new
    @title="用户注册"
    @user = User.new(:player => Player.new)
    render :template => nil
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])

    success = @user && @user.save

    if success && @user.errors.empty?
#     if @user = User.create(params[:user]) and @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      login_session(@user.player)
      redirect_to :controller => :players
      flash[:notice] = "你已经注册成功，谢谢你的注册."
      Player.find(params[:player_id]).get_money(10000) unless params[:player_id].blank?

    else
      flash[:error]  = "注册失败，请检查信息填写是否正确"
      render :action => 'new'
    end
  end

end
