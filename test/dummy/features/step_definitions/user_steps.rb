When /^the client requests GET (.*)$/ do |path|
  get(path)
end


Then /^the response should be JSON:$/ do |json|
  JSON.parse(last_response.body).should == JSON.parse(json)
end

Then /^the response should contain:$/ do |expected|
  # table is a Cucumber::Ast::Table
  actual = JSON.parse(last_response.body)
  p actual
  hashes = expected.hashes
  acutal_count = hashes.count
  expected.hashes.each { |row|
    row.each_key{|key|
      p "key = #{key}   "
    }
  }
end
