class Skill < ActiveRecord::Base
  acts_as_nameable
  has_many :adventurers   ,:through => :adventurer_skills
  has_many :adventurer_skills,  :dependent => :destroy
end
