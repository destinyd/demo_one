# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091231054815) do

  create_table "adventurer_skills", :force => true do |t|
    t.integer  "adventurer_id"
    t.integer  "skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adventurer_skills", ["adventurer_id"], :name => "index_adventurer_skills_on_adventurer_id"
  add_index "adventurer_skills", ["skill_id"], :name => "index_adventurer_skills_on_skill_id"

  create_table "adventurers", :force => true do |t|
    t.integer "hp",        :default => 100, :null => false
    t.integer "mhp",       :default => 100, :null => false
    t.integer "win",       :default => 0,   :null => false
    t.integer "lose",      :default => 0,   :null => false
    t.integer "kill",      :default => 0,   :null => false
    t.integer "job",                        :null => false
    t.integer "weapon_id"
    t.integer "armor_id"
    t.string  "plus"
    t.integer "player_id",                  :null => false
    t.integer "party_id"
  end

  add_index "adventurers", ["party_id"], :name => "index_adventurers_on_party_id"
  add_index "adventurers", ["player_id"], :name => "index_adventurers_on_player_id"

  create_table "auctions", :force => true do |t|
    t.integer  "player_id"
    t.integer  "highest_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "num"
    t.integer  "money"
    t.datetime "finish_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auctions", ["highest_id"], :name => "index_auctions_on_highest_id"
  add_index "auctions", ["player_id"], :name => "index_auctions_on_player_id"

  create_table "ddchats", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "body",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "effects", :force => true do |t|
    t.boolean  "target"
    t.boolean  "enemy"
    t.integer  "duration"
    t.integer  "number"
    t.string   "prototype"
    t.integer  "limit"
    t.integer  "cooldown"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", :force => true do |t|
    t.text     "body",       :null => false
    t.integer  "player_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["player_id"], :name => "index_feedbacks_on_player_id"

  create_table "fighters", :force => true do |t|
    t.integer  "hp",                               :null => false
    t.integer  "mhp",                              :null => false
    t.integer  "job",                              :null => false
    t.integer  "weapon_id"
    t.integer  "armor_id"
    t.string   "action"
    t.integer  "side",          :default => 0,     :null => false
    t.boolean  "over",          :default => false, :null => false
    t.integer  "scene_id",                         :null => false
    t.integer  "adventurer_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "plus",          :default => "",    :null => false
  end

  add_index "fighters", ["adventurer_id"], :name => "index_fighters_on_adventurer_id"
  add_index "fighters", ["scene_id"], :name => "index_fighters_on_scene_id"

  create_table "items", :force => true do |t|
    t.string   "type",       :limit => 20
    t.integer  "level"
    t.string   "property"
    t.string   "plus",                     :default => ""
    t.integer  "player_id"
    t.boolean  "vip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["level"], :name => "index_items_on_level"
  add_index "items", ["player_id"], :name => "index_items_on_player_id"
  add_index "items", ["vip"], :name => "index_items_on_vip"

  create_table "mails", :force => true do |t|
    t.string   "title",                         :null => false
    t.string   "body",                          :null => false
    t.string   "from"
    t.integer  "to_id",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "isread",     :default => false, :null => false
  end

  add_index "mails", ["from"], :name => "index_mails_on_from"
  add_index "mails", ["isread"], :name => "index_mails_on_isread"
  add_index "mails", ["to_id"], :name => "index_mails_on_to_id"

  create_table "names", :force => true do |t|
    t.string   "name",          :limit => 96,                    :null => false
    t.integer  "nameable_id"
    t.string   "nameable_type"
    t.integer  "player_id"
    t.boolean  "isnamed",                     :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "names", ["isnamed"], :name => "index_names_on_isnamed"
  add_index "names", ["player_id"], :name => "index_names_on_player_id"

  create_table "parties", :force => true do |t|
    t.string  "name"
    t.integer "adventurer_id", :null => false
  end

  add_index "parties", ["adventurer_id"], :name => "index_parties_on_adventurer_id"

  create_table "pets", :force => true do |t|
    t.integer  "hp",         :null => false
    t.string   "type"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pets", ["player_id"], :name => "index_pets_on_player_id"

  create_table "picks", :force => true do |t|
    t.integer  "ctype"
    t.integer  "level",      :default => 1
    t.integer  "player_id"
    t.datetime "picked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "picks", ["player_id"], :name => "index_picks_on_player_id"

  create_table "player_effects", :force => true do |t|
    t.datetime "at"
    t.datetime "finish_time"
    t.boolean  "finish"
    t.integer  "round"
    t.integer  "player_id"
    t.integer  "effect_id"
    t.integer  "scene_id"
    t.string   "scene_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "player_effects", ["effect_id"], :name => "index_player_effects_on_effect_id"
  add_index "player_effects", ["player_id"], :name => "index_player_effects_on_player_id"
  add_index "player_effects", ["scene_id", "scene_type"], :name => "index_player_effects_on_scene_id_and_scene_type"

  create_table "player_items", :force => true do |t|
    t.integer "player_id"
    t.integer "item_id"
    t.integer "amount"
    t.boolean "lock"
    t.boolean "known"
  end

  add_index "player_items", ["item_id"], :name => "index_player_items_on_item_id"
  add_index "player_items", ["known"], :name => "index_player_items_on_known"
  add_index "player_items", ["lock"], :name => "index_player_items_on_lock"
  add_index "player_items", ["player_id"], :name => "index_player_items_on_player_id"

  create_table "player_pets", :force => true do |t|
    t.integer  "hp",         :null => false
    t.integer  "food",       :null => false
    t.integer  "happy",      :null => false
    t.boolean  "pray"
    t.string   "needs"
    t.integer  "pet_id",     :null => false
    t.integer  "player_id",  :null => false
    t.datetime "grow_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "player_pets", ["pet_id"], :name => "index_player_pets_on_pet_id"
  add_index "player_pets", ["player_id"], :name => "index_player_pets_on_player_id"

  create_table "players", :force => true do |t|
    t.integer "money",      :default => 10000
    t.string  "title",      :default => ""
    t.string  "signed",     :default => ""
    t.integer "at"
    t.integer "can_change", :default => 1
    t.integer "user_id",                       :null => false
  end

  add_index "players", ["user_id"], :name => "index_players_on_user_id"

  create_table "pluginmags", :force => true do |t|
    t.integer "player_id", :null => false
    t.integer "plugin_id", :null => false
  end

  add_index "pluginmags", ["player_id"], :name => "index_pluginmags_on_player_id"
  add_index "pluginmags", ["plugin_id"], :name => "index_pluginmags_on_plugin_id"

  create_table "plugins", :force => true do |t|
    t.string   "name",                       :null => false
    t.text     "description"
    t.string   "url",                        :null => false
    t.integer  "can_change",  :default => 1, :null => false
    t.datetime "created_at"
    t.integer  "root",        :default => 0, :null => false
  end

  add_index "plugins", ["root"], :name => "index_plugins_on_root"

  create_table "scenes", :force => true do |t|
    t.integer  "scene",      :default => 0,     :null => false
    t.integer  "round",      :default => 1,     :null => false
    t.boolean  "over",       :default => false, :null => false
    t.text     "output"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops", :force => true do |t|
    t.integer  "item_id",    :null => false
    t.integer  "num",        :null => false
    t.integer  "price",      :null => false
    t.integer  "player_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["player_id"], :name => "index_shops_on_player_id"

  create_table "skills", :force => true do |t|
    t.integer  "job"
    t.string   "hits"
    t.integer  "player_id"
    t.string   "plus"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skills", ["player_id"], :name => "index_skills_on_player_id"

  create_table "statuses", :force => true do |t|
    t.string   "status"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statuses", ["player_id"], :name => "index_statuses_on_player_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "waits", :force => true do |t|
    t.integer  "adventurer_id"
    t.integer  "scene_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job",           :null => false
  end

  add_index "waits", ["adventurer_id"], :name => "index_waits_on_adventurer_id"
  add_index "waits", ["scene_id"], :name => "index_waits_on_scene_id"

end
