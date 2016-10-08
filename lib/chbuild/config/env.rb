# frozen_string_literal: true
module CHBuild
  class Config
    # Env section
    class Env < Hash
      def initialize(env = {})
        validate!(env)
        super
        replace(env) unless env.nil?
      end

      def validate!(_env)
        true
      end

      def errors
        []
      end

      def name
        "Section 'env'"
      end

      def to_bash_script
        reduce('') {|a, (k, v)| a + "export #{k}=\"#{v}\"\n" }
      end
    end
  end
end
