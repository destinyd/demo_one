class Pick < ActiveRecord::Base
  belongs_to :player
  validates_presence_of :ctype
  validates_presence_of :level
  validates_presence_of :picked_at
end
