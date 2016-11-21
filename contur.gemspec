# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/contur/version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'contur'
  spec.version       = Contur::VERSION
  spec.author        = 'Cheppers Ltd.'
  spec.email         = 'info@cheppers.com'
  spec.summary       = 'Contur - Local Web Development Tool'
  spec.homepage      = 'https://github.com/Cheppers/contur'
  spec.license       = 'MIT'
  spec.description   = IO.read('README.md').match(/# Contur\n^(?<desc>.*)$/)[:desc]

  spec.required_ruby_version = '>= 2.3.0'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['contur']
  spec.require_paths = ['lib']

  spec.add_dependency 'colorize', '~> 0.8'
  spec.add_dependency 'excon', '~> 0.46', '>= 0.46'
  spec.add_dependency 'docker-api', '~> 1.31', '>= 1.31'
  spec.add_dependency 'thor', '~> 0.19'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.44'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'simplecov-console', '~> 0.3'
end
