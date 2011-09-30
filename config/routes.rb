 Rails.application.routes.draw do
   # match 'with_id/:model/:id' => 'amos/amos#with_id'
   match ":model/:id" => "amos/amos#with_id", :constraints => { :model => /.*/ }
   match ":model" => "amos/amos#all", :constraints => { :model => /.*/ }
end