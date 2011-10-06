 Rails.application.routes.draw do
   # match 'with_id/:model/:id' => 'amos/amos#with_id'
   match ":model/find/:query" => "amos#find", :constraints => { :model => /.*/ }
   match ":model/:id" => "amos#show", :constraints => { :model => /.*/ }, :via => :get
   match ":model/:id" => "amos#destroy", :constraints => { :model => /.*/ }, :via => :delete
   match ":model/:id" => "amos#update", :constraints => { :model => /.*/ }, :via => :put
   match ":model" => "amos#create", :constraints => { :model => /.*/ }, :via => :post
   match ":model" => "amos#index", :constraints => { :model => /.*/ }
end