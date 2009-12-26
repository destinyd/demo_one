# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def showhits(hits,str)
    ""
  end
  
  def current_player
    current_user ?
      @current_player ||=  current_user.player :
      false 
  end

  def item_name(item)
    item.could_name?(current_player.id) ?
      link_to(item.name ,edit_item_path(item)) : item.name
  end

  def item_known(player_item)
    player_item.known ?
      link_to("属性",item_path(player_item.item)) : link_to("鉴定", identify_path(player_item.id))
  end
end
