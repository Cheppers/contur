# frozen_string_literal: true
When(/^I call "([^"]*)"$/) do |version_command|
  @response = `#{version_command}`
  expect(@response).to_not be_nil
end

Then(/^Contur tells it's version$/) do
  expect($CHILD_STATUS.exitstatus).to eq 0
end
