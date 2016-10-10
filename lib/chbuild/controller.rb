# frozen_string_literal: true
require 'docker-api'
require 'erb'

require 'chbuild/bindable_hash'
require 'chbuild/config'
require 'chbuild/utils'

# rubocop:disable Metrics/ClassLength, Lint/AssignmentInCondition

# CHBuild main module
module CHBuild
  # CHBuild::Controller
  class Controller
    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    def self.config(path_to_config = nil)
      # rubocop:disable Style/ClassVars
      @@config ||= nil

      unless @@config
        @@config = if path_to_config.nil?
                     CHBuild::Config.new(File.join(Dir.pwd, '.chbuild.yml'))
                   else
                     CHBuild::Config.new(path_to_config)
                   end
      end
      @@config
    end

    def self.image_exist?
      Docker::Image.exist? CHBuild::IMAGE_NAME
    end

    def self.container?
      Docker::Container.all(
        'filters' => { 'ancestor' => [CHBuild::IMAGE_NAME] }.to_json, 'all' => true
      ).first
    rescue
      nil
    end

    def self.promote
      puts '!!! WIP !!!'
      puts "FQDN: #{CHBuild::Utils.fqdn}"
    end

    def self.build
      template = load_docker_template(
        'base-docker-container',
        php_memory_limit: '128M'
      )

      docker_context = generate_docker_archive(template)

      Docker::Image.build_from_tar(docker_context, t: CHBuild::IMAGE_NAME) do |r|
        r.each_line do |log|
          if (message = JSON.parse(log)) && message.key?('stream')
            yield message['stream'] if block_given?
          end
        end
      end
    end

    def self.run(config_path: nil, webroot: nil, initscripts: nil) # rubocop:disable Metrics/LineLength, Lint/UnusedMethodArgument
      return false unless image_exist?

      bind_volumes = []

      if !webroot.nil? && Dir.exist?(File.expand_path(webroot))
        bind_volumes << "#{webroot}:/www"
      end
      if !initscripts.nil? && Dir.exist?(File.expand_path(initscripts))
        bind_volumes << "#{initscripts}:/initscripts"
      end

      if c = container?
        yield 'Removing existing chbuild container...' if block_given?
        c.remove(force: true)
      end

      mysql_container_version = "mysql:#{config.use['mysql']}"
      unless Docker::Image.exist? mysql_container_version
        yield "Downloading #{mysql_container_version}..." if block_given?
        Docker::Image.create('fromImage' => mysql_container_version)
      end

      mysql_container_name = mysql_container_version.tr(':.', '_')

      stop_mysql_containers(except: mysql_container_version)
      begin
        mysql_container = Docker::Container.get(mysql_container_name)
      rescue Docker::Error::NotFoundError
        yield 'Creating MySQL container...' if block_given?
        mysql_container = Docker::Container.create(
          'name' => mysql_container_name,
          'Image' => mysql_container_version,
          'Env' => ['MYSQL_ROOT_PASSWORD=admin']
        )
      ensure
        mysql_container_info = Docker::Container.get(mysql_container.id).info
        unless mysql_container_info['State']['Running']
          yield 'Starting MySQL container...' if block_given?
          mysql_container.start!
          sleep 10
        end
      end
      mysql_container_info = Docker::Container.get(mysql_container.id).info
      unless mysql_container_info['State']['Running']
        yield "Couldn't start MySQL container" if block_given?
        return false
      end
      yield "MySQL container: #{mysql_container.id[0, 10]}" if block_given?

      yield 'Creating CHBuild container...' if block_given?
      container = Docker::Container.create(
        'name' => CHBuild::Utils.generate_conatiner_name,
        'Image' => CHBuild::IMAGE_NAME,
        'Cmd' => ['/init.sh'],
        'Volumes' => {
          "#{Dir.pwd}/webroot" => {},
          "#{Dir.pwd}/initscripts" => {}
        },
        'ExposedPorts' => {
          '80/tcp' => {}
        },
        'HostConfig' => {
          'Links' => ["#{mysql_container_name}:mysql"],
          'PortBindings' => {
            '80/tcp' => [{ 'HostPort' => '8088' }]
          },
          'Binds' => bind_volumes
        }
      )

      container.store_file('/init.sh', content: load_init_script, permissions: 0777)

      container.start!
    end

    def self.delete_container
      if c = container?
        c.delete(force: true)
        true
      else
        false
      end
    end

    def self.container_id
      if c = container?
        c.id[0, 10]
      end
    end

    def self.container_logs
      if c = container?
        c.logs(stdout: true)
      end
    end

    def self.delete_image
      if image_exist?
        image = Docker::Image.get CHBuild::IMAGE_NAME
        image.remove(force: true)
      end
    end

    def self.mysql_containers
      Docker::Container.all.select { |c| c.info['Image'].start_with?('mysql') }
    end

    def self.delete_mysql_containers
      if mysql_containers.empty?
        false
      else
        mysql_containers.each { |c| c.delete(force: true) }
        true
      end
    end

    def self.stop_mysql_containers(except: "\n")
      mysql_containers.select { |c| c.info['Image'].end_with?(except) }.each(&:stop)
    end

    private_class_method

    def self.load_docker_template(template_name, opts = {})
      opts = CHBuild::DEFAULT_OPTS.merge(opts)

      context = BindableHash.new opts
      ::ERB.new(
        File.read("#{CHBuild::TEMPLATE_DIR}/#{template_name}.erb")
      ).result(context.get_binding)
    end

    def self.load_init_script
      context = BindableHash.new(before_script: config.init_script)
      ::ERB.new(
        File.read("#{CHBuild::TEMPLATE_DIR}/init.sh.erb")
      ).result(context.get_binding)
    end

    def self.generate_docker_archive(dockerfile_content)
      tar = StringIO.new

      Gem::Package::TarWriter.new(tar) do |writer|
        writer.add_file('Dockerfile', 0644) { |f| f.write(dockerfile_content) }
      end

      compress_archive(tar)
    end

    def self.compress_archive(tar)
      tar.seek(0)
      # rubocop:disable Style/EmptyLiteral
      gz = StringIO.new(String.new, 'r+b').set_encoding(Encoding::BINARY)
      gz_writer = Zlib::GzipWriter.new(gz)
      gz_writer.write(tar.read)
      tar.close
      gz_writer.finish
      gz.rewind

      gz
    end
  end
end
