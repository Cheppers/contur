# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'cucumber/rake/task'

RuboCop::RakeTask.new(:rubocop) { |t| t.options << '-D' }
RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:features) { |t| t.cucumber_opts = '--format pretty' }

task default: %i[rubocop spec features]
