# frozen_string_literal: true

require 'fileutils'
require 'rspec'
require 'English'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Before do
  @tmpdir = Dir.mktmpdir
end

After do
  FileUtils.remove_entry_secure @tmpdir
end
