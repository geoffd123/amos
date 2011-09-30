 Rails.application.routes.draw do |map|
   match ":model/:method' => 'amos_controller#access'
 end