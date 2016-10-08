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
    end
  end
end
