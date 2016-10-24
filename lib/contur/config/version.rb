# frozen_string_literal: true
module Contur
  class Config
    # Version section
    class Version
      ALLOWED_VALUES ||= [1.0].freeze

      # version is required so no default value
      def initialize(version)
        validate!(version)
        @yaml_version = version
      end

      def inspect
        @yaml_version.to_s
      end

      def validate!(version)
        @errors = []
        if version.nil?
          @errors << 'Required'
          return
        end
        @errors << "Unknown value: '#{version}'" unless ALLOWED_VALUES.include? version
      end

      attr_reader :errors

      def name
        "Section 'version'"
      end
    end
  end
end
