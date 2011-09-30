 Rails.application.routes.draw do
   match 'with_id/:model/:id' => 'amos/amos#with_id'
   match 'all/:model' => 'amos/amos#all'
end