# frozen_string_literal: true

# Contur module :D
module Contur
  # BindableHash is for ERB templates
  class BindableHash
    def initialize(hash)
      hash.each do |key, value|
        singleton_class.send(:define_method, key) { value }
      end
    end

    def get_binding # rubocop:disable Style/AccessorMethodName
      binding
    end
  end
end
