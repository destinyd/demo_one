class Fighter < ActiveRecord::Base
  belongs_to :scene
  belongs_to :adventurer
end
