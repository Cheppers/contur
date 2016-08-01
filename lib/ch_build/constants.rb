# frozen_string_literal: true
# CHBuild main module
module CHBuild
  GEM_ROOT       = File.expand_path(File.join(File.dirname(__FILE__), '../../'))
  TEMPLATE_DIR   = "#{CHBuild::GEM_ROOT}/templates"
  DEFAULT_DOMAIN = 'cheppers.com'

  IMAGE_NAME ||= 'ch-build'
  DOCKER_DIR ||= 'docker'

  def default_template_variables
    {
      refreshed_at_date: Date.today.strftime('%Y-%m-%d'),
      php_timezone: 'Europe/Budapest',
      php_memory_limit: '256M',
      max_upload: '50M',
      php_max_file_upload: 200,
      php_max_post: '100M',
      extra_files: CHBuild::TEMPLATE_DIR
    }
  end
end
