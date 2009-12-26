class Ddchat < ActiveRecord::Base
  validates_presence_of :name,:body
  validates_length_of :body,  :maximum => 80
end
