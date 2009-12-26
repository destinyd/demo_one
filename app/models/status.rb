class Status < ActiveRecord::Base
  belongs_to :player

  validates_presence_of :status,:message => "状态不能为空"
  validates_presence_of :player_id

end
