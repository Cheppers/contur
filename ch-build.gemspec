# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/ch_build/version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'ch-build'
  spec.version       = CHBuild::VERSION
  spec.authors       = [
    'Balazs Nadasdi',
    'Gabor Takacs'
  ]
  spec.email = [
    'balazs.nadasdi@cheppers.com',
    'gabor.takacs@cheppers.com'
  ]

  spec.summary       = 'Cheppers Build Tool for Drupal Projects'
  spec.homepage      = 'https://gitlab.cheppers.com/ch-build/ch-build'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['ch-build']
  spec.require_paths = ['lib']

  spec.add_dependency 'colorize', '~> 0.8'
  spec.add_dependency 'docker-api', '~> 1.28'
  spec.add_dependency 'thor', '~> 0.19'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'overcommit', '~> 0.32'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.40'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
