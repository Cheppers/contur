# frozen_string_literal: true
module Contur
  class Config
    # Before section
    class Before < Array
      # before_commands is required so no default value
      def initialize(before_commands)
        super([])
        validate!(before_commands)
        replace(before_commands) unless before_commands.nil?
      end

      def validate!(before_commands)
        @errors = []
        @errors << 'Required' if before_commands.nil?
        @errors << 'Cannot be empty' if before_commands == []
      end

      attr_reader :errors

      def name
        "Section 'before'"
      end

      def to_bash_script
        reduce('') { |a, e| a + "#{e}\n" }
      end
    end
  end
end
