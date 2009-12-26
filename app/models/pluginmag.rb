class Pluginmag < ActiveRecord::Base
  belongs_to :player
  belongs_to :plugin
	validates_uniqueness_of :plugin_id, :scope => [:player_id, :plugin_id]
end
