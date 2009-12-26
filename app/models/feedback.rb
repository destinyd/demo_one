class Feedback < ActiveRecord::Base
  validates_presence_of :body
  belongs_to :player
end
