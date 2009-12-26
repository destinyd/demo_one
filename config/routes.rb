ActionController::Routing::Routes.draw do |map|
#    map.resources :adventures,:expect => [:destroy],:collection => {
#      :train => :get,:ptrain => :post,
#      :fight => :get,:pfight => :post,:wfight => :get,:sfight => :get,
#      :adventure => :get,:padventure => :post,
#      :solo => :get,:psolo => :post,
#      :find_party => :get,:party => :get,
#      :create_party => :post,:join_party => :post,:party_wait => :get
#    }

  map.namespace :adventure do |ad|
    ad.resources :adventures
    ad.resources :fight_waits
    ad.resources :party_waits
    ad.resources :party_adventures
    ad.resources :partys
    ad.resources :solos
    ad.resources :trains
    ad.resources :fights
    ad.resources :jobs
  end

  map.resources :ddchats,:only => [:index,:create]
  map.resources :feedbacks,:only => [:index,:create]
  map.resources :pets
  map.resources :player_pets,:member => {
    :feed => :post,
    :play => :post#,
#    :pray => :post,
#    :kill => :post
  },:collection => {:mix => :post}

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users

  map.resource :session


  map.resources :identifies
  map.resources :mails
  map.resources :auctions,:member => {:min => :post}
  map.resources :shops,:member => {:buy => :put}

  map.resources :equips
  map.resources :users
  map.resource :session
  map.resources :pluginmanages
  map.resources :picks,:collection => {:level_up => :get}

  map.resources :player_items
  map.resources :items
  
  map.resources :players,:collection => {:set_player_signed => :post}  do |p|
    p.resources :shops
  end
  map.resources :makes
  map.resources :swordworlds,:collection => {:fightself => :get,
    :pfightself => :put,:waitfight => :get,:stopfight => :get,:pfight => :put,
    :fight => :get,:skillslist => :get
  }

  map.root :controller => "homepage",:action => 'index'
  map.start '/start',:controller => "homepage",:action => 'show'
  map.home '/myhome',:controller => "myhome"
  map.invent '/invent',:controller => "myhome",:action => 'invent'
end
