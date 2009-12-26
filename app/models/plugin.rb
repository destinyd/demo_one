class Plugin < ActiveRecord::Base
  has_many :pluginmags,:dependent => :destroy
  has_many :players, :through => :pluginmags
  has_many :plugins,:foreign_key  => "root"

  named_scope :roots,:conditions => "root=0"
end
