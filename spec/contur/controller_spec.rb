# frozen_string_literal: true

require 'yaml'
require 'contur/controller'

describe Contur::Controller do
  it '#default_yaml' do
    expect(Contur::Controller.default_yaml).to_not be_empty
    expect(Contur::Controller.default_yaml).to be_a String
    expect { YAML.parse(Contur::Controller.default_yaml) }.to_not raise_error Psych::SyntaxError
  end
end
