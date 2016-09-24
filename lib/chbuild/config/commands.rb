# frozen_string_literal: true
module CHBuild
  class Config
    # Commands section
    class Commands < Array
      # commands is required so no default value
      def initialize(commands)
        super([])
        validate!(commands)
        replace(commands) unless commands.nil?
      end

      def validate!(commands)
        @errors = []
        @errors << 'Required' if commands.nil?
        @errors << 'Cannot be empty' if commands == []
      end

      attr_reader :errors

      def name
        "Section 'commands'"
      end
    end
  end
end
