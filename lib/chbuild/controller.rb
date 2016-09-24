require 'docker-api'
require 'erb'

require 'chbuild/bindable_hash'
require 'chbuild/config'
require 'chbuild/utils'

# rubocop:disable Metrics/ClassLength

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
      Docker::Container.all('filters' => {'ancestor' => [CHBuild::IMAGE_NAME]}.to_json, 'all' => true).first
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
        c.remove(force: true)
      end

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

    private_class_method

    def self.load_docker_template(template_name, opts = {})
      opts = CHBuild::DEFAULT_OPTS.merge(opts)

      context = BindableHash.new opts
      ::ERB.new(
        File.read("#{CHBuild::TEMPLATE_DIR}/#{template_name}.erb")
      ).result(context.get_binding)
    end

    def self.load_init_script
      context = BindableHash.new(yaml_init: config.init_script)
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
      gz = StringIO.new('', 'r+b')
      gz.set_encoding('BINARY')
      gz_writer = Zlib::GzipWriter.new(gz)
      gz_writer.write(tar.read)
      tar.close
      gz_writer.finish
      gz.rewind

      gz
    end
  end
end
