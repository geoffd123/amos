
When /^the client requests GET (.*)$/ do |path|
  get(path)
end

When /^the client requests DELETE (.*)$/ do |path|
  delete(path)
end

When /^the client requests POST (.*) with name "([^"]*)" and email "([^"]*)"$/ do |path, name, email|
  post(path, :name => name, :email => email)
end

When /^the client requests PUT (.*) with name "([^"]*)" and email "([^"]*)"$/ do |path, name, email|
  put(path, :name => name, :email => email)
end

Then /^the response should be JSON:$/ do |json|
  JSON.parse(last_response.body).should == JSON.parse(json)
end

Then /^the response should be status "([^"]*)" with JSON:$/ do |status, json|
  last_response.status.should == status.to_i
  JSON.parse(last_response.body).should == JSON.parse(json)
end


Given /^"([^"]*)" belongs to "([^"]*)"$/ do |recipe_name, user_name|
  rp = Recipe.find_by_name(recipe_name)
  raise "Cannot find recipe with name #{recipe_name}" if rp.nil?
  u = User.find_by_name(user_name)
  raise "Cannot find user with name #{user_name}" if u.nil?
  u.recipes << rp
  u.save
end

Given /^pagination is set for "([^"]*)" model$/ do |model|
  self.instance_eval("#{model}.paginate_results")
end

Given /^there are (\d+) items per page$/ do |num|
  WillPaginate.per_page = num
end

Given /^I have setup my ability class$/ do |code|
  eval code
end

Given /^I am not logged in$/ do
  class AmosApplicationController < ActionController::Base
    def current_user
      nil
    end
  end
end


