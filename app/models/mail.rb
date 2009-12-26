class Mail < ActiveRecord::Base
  belongs_to :player
  attr_accessor :to_name
  attr_accessible :body,:to_id,:title
end
