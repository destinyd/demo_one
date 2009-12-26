class PluginmanagesController < ApplicationController
  before_filter :with_user
  # GET /pluginmanages
  # GET /pluginmanages.xml
  def index
    @title="游戏世界"
    @subtitle="游戏管理"
    @pluginmanages = current_player.plugins
  end

  # GET /pluginmanages/1
  # GET /pluginmanages/1.xml
  def show
    @pluginmanage = Plugin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pluginmanage }
    end
  end

  # GET /pluginmanages/new
  # GET /pluginmanages/new.xml
  def new
    @title="游戏世界"
    @subtitle="添加游戏"
    @plugins = Plugin.find(:all,:conditions => "root=0")
    @pluginmanage=Pluginmag.new
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pluginmanage }
    end
  end

  # POST /pluginmanages
  # POST /pluginmanages.xml
  def create
    @pluginmanage = Pluginmag.new(:player_id=>session[:player_id],:plugin_id=>params[:pluginmanage][:plugin_id])
    respond_to do |format|
      if @pluginmanage.save
				session[:plugin_ids]=Player.find(session[:player_id]).plugin_ids
        flash[:notice] = '游戏添加成功。'
        format.html { redirect_to(pluginmanages_url) }
      else
        format.html { redirect_to(pluginmanages_url)}
      end
    end
  end


  # DELETE /pluginmanages/1
  # DELETE /pluginmanages/1.xml
  def destroy
    Pluginmag.delete_all(:player_id=>session[:player_id],:plugin_id => params[:id])
		session[:plugin_ids]=Player.find(session[:player_id]).plugins
    flash[:notice]="游戏删除成功。"
    respond_to do |format|
      format.html { redirect_to(pluginmanages_url) }
      format.xml  { head :ok }
    end
  end
end
