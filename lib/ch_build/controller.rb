# frozen_string_literal: true
require 'docker-api'

module CHBuild
  # CHBuild::Controller
  class Controller
    def self.image_exist?
      Docker::Image.exist? CHBuild::IMAGE_NAME
    end

    def self.container_exist?
      !Docker::Container.all('Names' => [CHBuild::IMAGE_NAME]).empty?
    end

    def self.build
      Docker::Image.build_from_dir(CHBuild::DOCKER_DIR, t: CHBuild::IMAGE_NAME) do |r|
        r.each_line do |log|
          if (message = JSON.parse(log)) && message.key?('stream')
            yield message['stream'] if block_given?
          end
        end
      end
    end

    def self.run
      return false unless image_exist?

      if container_exist?
        Docker::Container.get(CHBuild::IMAGE_NAME).remove(force: true)
      end

      container = Docker::Container.create(
        'name' => CHBuild::IMAGE_NAME,
        'Image' => CHBuild::IMAGE_NAME,
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
          'Binds' => [
            "#{Dir.pwd}/webroot:/www",
            "#{Dir.pwd}/initscripts:/initscripts"
          ]
        }
      )

      container.start
    end

    def self.clean
      if container_exist?
        container = Docker::Container.get CHBuild::IMAGE_NAME
        container.delete(force: true)
        yield 'container' if block_given?
      end

      if image_exist?
        image = Docker::Image.get CHBuild::IMAGE_NAME
        image.remove(force: true)
        yield 'image' if block_given?
      end
    end
  end
end
