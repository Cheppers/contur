# frozen_string_literal: true
require 'contur/config/before'
require 'contur/config/env'
require 'contur/config/errors'
require 'contur/config/use'
require 'contur/config/version'

require 'yaml'

module Contur
  # Build configuration object
  class Config
    attr_reader :path, :raw, :version, :use, :env, :before

    # @TODO refactor this to expect a string not a path, read the file in the controller
    def initialize(path_to_config)
      begin
        @path = path_to_config
        build_config = YAML.load_file(path_to_config)
      rescue Errno::ENOENT
        raise Contur::Config::NotFoundError, "'#{path_to_config}': file not found"
      end

      @errors = []
      unless build_config
        @errors << 'File: Build file is empty'
        return
      end

      @raw = build_config
      @version = Version.new(build_config['version'])
      @use = Use.new(build_config['use'])
      @env = Env.new(build_config['env'])
      @before = Before.new(build_config['before'])
    end

    def init_script
      unless @init_script
        generation_time = "echo \"Generated at: [#{Time.now}]\"\n\n"
        env_script = @env.to_bash_script
        before_script = @before.to_bash_script
        @init_script = generation_time + env_script + before_script
      end
      @init_script
    end

    def errors
      all_errors = Array.new(@errors)

      instance_variables.each do |var|
        section = instance_variable_get(var)
        next unless section.respond_to?(:name) && section.respond_to?(:errors)
        section_name = section.send(:name)
        section_errors = section.send(:errors)
        section_errors.each do |err|
          all_errors << "#{section_name}: #{err}"
        end
      end

      all_errors
    end

    def inspect
      data = []
      instance_variables.each do |var|
        section = instance_variable_get(var)
        if section.respond_to?(:name)
          section_name = section.send(:name)
          data << "#{section_name}: #{section.inspect}"
        end
      end
      data.join("\n")
    end
  end
end
