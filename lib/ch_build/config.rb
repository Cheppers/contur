# frozen_string_literal: true
require 'ch_build/config/commands'
require 'ch_build/config/env'
require 'ch_build/config/errors'
require 'ch_build/config/use'
require 'ch_build/config/version'

require 'yaml'

module CHBuild
  # Build configuration object
  class Config
    attr_reader :path, :raw, :version, :use, :env, :commands

    def initialize(path_to_config)
      begin
        @path = path_to_config
        build_config = YAML.load_file(path_to_config)
      rescue Errno::ENOENT
        raise CHBuild::Config::NotFoundError, "'#{path_to_config}': file not found"
      end

      @errors = []
      unless build_config
        @errors << 'Build file is empty'
        return
      end

      @raw = build_config
      @version = Version.new(build_config['version'])
      @use = Use.new(build_config['use'])
      @env = Env.new(build_config['env'])
      @commands = Commands.new(build_config['commands'])
    end

    def init_script
      unless @init_script
        shebang = "#!/bin/bash\n\n"
        generation_time = "# Generated at: [#{Time.now}]\n\n"
        commands = @commands.reduce('') { |s, command| s + "#{command}\n" }
        @init_script = shebang + generation_time + commands
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
