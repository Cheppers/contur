# frozen_string_literal: true

module Contur
  class Config
    # Before section
    class Before < Array
      def initialize(before_commands = [])
        super([])
        validate!(before_commands)
        replace(before_commands) unless before_commands.nil?
      end

      def validate!(_before_commands)
        @errors = []
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
