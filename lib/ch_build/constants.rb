# frozen_string_literal: true
# CHBuild main module
module CHBuild
  GEM_ROOT      = File.expand_path(File.join(File.dirname(__FILE__), '../../'))
  TEMPLATE_DIR  = "#{CHBuild::GEM_ROOT}/templates"

  IMAGE_NAME ||= 'ch-build'
  DOCKER_DIR ||= 'docker'
end
