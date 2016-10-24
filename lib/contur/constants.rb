# frozen_string_literal: true

require 'date'

# Contur main module
module Contur
  GEM_ROOT       = File.expand_path(File.join(File.dirname(__FILE__), '../../'))
  TEMPLATE_DIR   = "#{Contur::GEM_ROOT}/templates"
  DEFAULT_DOMAIN = 'cheppers.com'

  IMAGE_NAME ||= 'contur'
  DOCKER_DIR ||= 'docker'
  DEFAULT_PHP_VERSION = '5.6'
  DEFAULT_MYSQL_VERSION = 'latest'

  DEFAULT_OPTS ||= {
    refreshed_at_date: ::Date.today.strftime('%Y-%m-%d'),
    php_timezone: 'Europe/Budapest',
    php_memory_limit: '256M',
    max_upload: '50M',
    php_max_file_upload: 200,
    php_max_post: '100M',
    extra_files: Contur::TEMPLATE_DIR
  }.freeze
end
