class MailsController < ApplicationController
  before_filter :with_user
  before_filter :title
  def index
    @mails    = Mail.paginate_all_by_to_id(
      session[:player_id],
      :order => "id desc",
      :page => params[:mailpage],
      :per_page => 10
    )
  end

  def new
    @mail   = Mail.new(params[:mail])
    @mail.to_name = params[:mail][:to_name] if params[:mail]
    if params[:mail]
      @mail.title = "回复：" + @mail.title
      @subtitle = "回复消息"
    else
      @subtitle = "写消息"
    end
  end

  def create
    to_name=params[:mail][:to_name].strip
    @player = Name.find_by_name(to_name).nameable unless to_name.blank?
    unless @player
      index_by_flash("没有叫这名字的人")
      return
    end
    if current_player.is_self?(@player)
      index_by_flash("你不能给自己写信")
      return
    end
    @mail =  Mail.new(params[:mail])
    @mail.to_id = @player.id
    @mail.title = @mail.title.strip
    @mail.body  = @mail.body.strip
    @mail.from  = current_player.name
    @mail.save
    index_by_flash("发送消息成功")
  end

  def destroy
    @mail = Mail.find(params[:id])
    if @mail.to_id == session[:player_id]
      @mail.destroy
      index_by_flash("消息成功删除")
    else
      index_by_flash("这不是你的信件")
    end
  end

  def show
    @mail = Mail.find(params[:id])
    unless @mail.to_id == session[:player_id]
      index_by_flash("这不是你的信件")
      return
    end
    @mail.isread=true
    @mail.save
    @subtitle = "消息详情"
  end

  private
  def title
    @title = "消息箱"
  end

end
