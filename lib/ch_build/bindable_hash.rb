# frozen_string_literal: true
# CHBuild module :D
module CHBuild
  # BindableHash is for ERB templates
  class BindableHash
    def initialize(hash)
      hash.each do |key, value|
        singleton_class.send(:define_method, key) { value }
      end
    end

    def binding
      binding
    end
  end
end
