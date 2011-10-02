 Rails.application.routes.draw do
   # match 'with_id/:model/:id' => 'amos/amos#with_id'
   match ":model/:id" => "amos/amos#show", :constraints => { :model => /.*/ }, :via => :get
   match ":model/:id" => "amos/amos#destroy", :constraints => { :model => /.*/ }, :via => :delete
   match ":model/:id" => "amos/amos#update", :constraints => { :model => /.*/ }, :via => :put
   match ":model" => "amos/amos#create", :constraints => { :model => /.*/ }, :via => :post
   match ":model" => "amos/amos#index", :constraints => { :model => /.*/ }
end