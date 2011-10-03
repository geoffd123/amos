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

Given /^"([^"]*)" belongs to "([^"]*)"$/ do |recipe_name, user_name|
  rp = Recipe.find_by_name(recipe_name)
  raise "Cannot find recipe with name #{recipe_name}" if rp.nil?
  u = User.find_by_name(user_name)
  raise "Cannot find user with name #{user_name}" if u.nil?
  u.recipes << rp
  u.save
end
