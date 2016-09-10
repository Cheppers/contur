# frozen_string_literal: true

require 'ch_build/constants'

module CHBuild
  class Config
    # Use section
    class Use < Hash
      DEFAULTS ||= {
        'php' => CHBuild::DEFAULT_PHP_VERSION,
        'mysql' => CHBuild::DEFAULT_MYSQL_VERSION
      }.freeze

      ALLOWED_VALUES ||= DEFAULTS.keys

      def initialize(using = {})
        super
        replace(DEFAULTS)

        validate!(using)

        merge(using)
      end

      def validate!(using)
        @errors = []
        if using.respond_to? :keys
          extra_keys = using.keys - ALLOWED_VALUES
          extra_keys.each do |key|
            @errors << "Unknown key: #{key}"
          end
        end
      end

      attr_reader :errors

      def name
        "Section 'use'"
      end
    end
  end
end
