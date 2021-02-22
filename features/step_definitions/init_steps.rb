# frozen_string_literal: true

Given(/^I have an empty directory$/) do
  expect(Dir.entries(@tmpdir).size).to eq 2
end

When(/^I run "([^"]*)" in the directory$/) do |command|
  resp = `cd #{@tmpdir} && #{command}`
  @response = resp.gsub(/\e\[(\d+)(;\d+)*m/, '').chomp
end

Then(/^I have a new \.contur\.yml$/) do
  expect(File.exist?(File.join(@tmpdir, '.contur.yml'))).to be true
end

Then(/^it contains:$/) do |string|
  expect(string).to eq IO.read(File.join(@tmpdir, '.contur.yml')).chomp
end

Given(/^I have a directory with \.contur\.yml$/) do
  IO.write(File.join(@tmpdir, '.contur.yml'), '')
  expect(File.exist?(File.join(@tmpdir, '.contur.yml'))).to be true
end

Then(/^the CLI returns exit code (\d+)$/) do |exit_code|
  expect($CHILD_STATUS.exitstatus).to eq exit_code.to_i
end

Then(/^it prints to the console:$/) do |output|
  expect(@response).to eq output
end
