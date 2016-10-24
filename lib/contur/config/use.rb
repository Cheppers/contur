# frozen_string_literal: true

require 'contur/constants'

module Contur
  class Config
    # Use section
    class Use < Hash
      DEFAULTS ||= {
        'php' => Contur::DEFAULT_PHP_VERSION,
        'mysql' => Contur::DEFAULT_MYSQL_VERSION
      }.freeze

      ALLOWED_VALUES ||= DEFAULTS.keys

      def initialize(using = {})
        super
        replace(DEFAULTS)

        validate!(using)

        merge!(using) unless using.nil?
      end

      def validate!(using)
        @errors = []
        return unless using.respond_to? :keys
        extra_keys = using.keys - ALLOWED_VALUES
        extra_keys.each do |key|
          @errors << "Unknown key: #{key}"
        end
      end

      attr_reader :errors

      def name
        "Section 'use'"
      end
    end
  end
end
