StageCom::Application.routes.draw do

  faye_server '/faye', :timeout => 25
  
  root :to => 'home#index'
end
