 Rails.application.routes.draw do
   match '/access/:model/:method' => 'amos/amos#access'
end