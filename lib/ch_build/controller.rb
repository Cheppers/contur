# frozen_string_literal: true
require 'docker-api'
require 'pp'

# CHBuild main module
module CHBuild
  # CHBuild::Controller
  class Controller
    def self.image_exist?
      Docker::Image.exist? CHBuild::IMAGE_NAME
    end

    def self.container_exist?
      Docker::Container.get(CHBuild::IMAGE_NAME)
      true
    rescue
      false
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

    def self.run(webroot: nil, initscripts: nil)
      return false unless image_exist?

      bind_volumes = []

      bind_volumes << "#{webroot}:/www" unless webroot.nil?
      bind_volumes << "#{initscripts}:/initscripts" unless initscripts.nil?

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
          'Binds' => bind_volumes
        }
      )

      container.start
    end

    def self.clean
      delete_container
      delete_image
    end

    def self.delete_container
      if container_exist?
        container = Docker::Container.get CHBuild::IMAGE_NAME
        container.delete(force: true)
      end
    end

    def self.delete_image
      if image_exist?
        image = Docker::Image.get CHBuild::IMAGE_NAME
        image.remove(force: true)
      end
    end
  end
end
