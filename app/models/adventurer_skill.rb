class AdventurerSkill < ActiveRecord::Base
  belongs_to :adventurer
  belongs_to :skill
end
