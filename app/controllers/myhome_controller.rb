class MyhomeController < ApplicationController
  before_filter :with_user
  def index
    @title="最近状态"
    @statuses = Status.paginate_all_by_player_id(
      session[:player_id],
      :order => "id desc",
      :page => params[:page],
      :per_page => 10
    )
  end
  def invent
    @title="邀请好友"
    @player=current_player
  end
end
