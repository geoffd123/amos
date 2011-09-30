 Rails.application.routes.draw do
   # match 'with_id/:model/:id' => 'amos/amos#with_id'
   match ":model/:id" => "amos/amos#delete_with_id", :constraints => { :model => /.*/ }, :via => :delete
   match ":model/:id" => "amos/amos#get_with_id", :constraints => { :model => /.*/ }
   match ":model" => "amos/amos#all", :constraints => { :model => /.*/ }
end