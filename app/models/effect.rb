class Effect < ActiveRecord::Base
  has_many :player_effects
  has_many :players, :through => :player_effects
end
