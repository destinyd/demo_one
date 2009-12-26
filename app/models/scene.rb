class Scene < ActiveRecord::Base
  has_many :fighters,:order => "id asc"
end
