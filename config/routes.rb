 Rails.application.routes.draw do
   match 'all/:model' => 'amos/amos#all'
end