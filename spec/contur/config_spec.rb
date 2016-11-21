# frozen_string_literal: true
require 'contur/config'
require 'contur/config/errors'

describe Contur::Config do
  def write_config_to_file(cont)
    t = Tempfile.new
    t.write cont
    t.close
    t
  end

  context '#new' do
    it 'with a valid file' do
      valid_config_content = <<-EOF
---
version: 1.0
env:
  TEST_VAR: test
before:
  - echo "TEST"
      EOF

      file = write_config_to_file(valid_config_content)
      cfg = Contur::Config.new(file.path)

      expect(cfg.errors).to be_empty

      file.delete
    end

    it 'with an empty file' do
      file = write_config_to_file('')
      cfg = Contur::Config.new(file.path)

      expect(cfg.errors).to_not be_empty
      expect(cfg.errors).to include 'File: Build file is empty'

      file.delete
    end

    it 'with a bad file path' do
      path = 'dummy_path_7823gr7bcb'
      expect { Contur::Config.new(path) }.to raise_error Contur::Config::NotFoundError
    end
  end

  it '#errors' do
    wrong_version_content = <<-EOF
---
version: 2.1
use:
  nginx: 1.9.11
    EOF

    file = write_config_to_file(wrong_version_content)
    cfg = Contur::Config.new(file.path)

    expect(cfg.errors).to_not be_empty
    expect(cfg.errors).to include "Section 'version': Unknown value: '2.1'"
    expect(cfg.errors).to include "Section 'use': Unknown key: nginx"

    file.delete
  end

  it '#init_script' do
    config_content = <<-EOF
---
version: 1.0
env:
  TEST_VAR: test
before:
  - echo "TEST"
    EOF

    file = write_config_to_file(config_content)
    cfg = Contur::Config.new(file.path)

    expect(cfg.errors).to be_empty
    config_regex = /echo \"Generated at: \[.*\]\"\s+export TEST_VAR=\"test\"\necho \"TEST\"/
    expect(cfg.init_script).to match config_regex

    file.delete
  end

  context '#inspect' do
    it 'with default values' do
      config_content = <<-EOF
---
version: 1.0
env:
  TEST_VAR: test
before:
  - echo "TEST"
      EOF

      file = write_config_to_file(config_content)
      cfg = Contur::Config.new(file.path)

      inspected_cfg = <<-EOF
Section 'version': 1.0
Section 'use': {"php"=>"5.6", "mysql"=>"latest"}
Section 'env': {"TEST_VAR"=>"test"}
Section 'before': [\"echo \\\"TEST\\\"\"]
      EOF
      inspected_cfg = inspected_cfg.chomp

      expect(cfg.errors).to be_empty
      expect(cfg.inspect).to eq inspected_cfg

      file.delete
    end

    it 'with explicit values' do
      config_content = <<-EOF
---
version: 1.0
use:
  php: 7.1
  mysql: 5.5.25
env:
  TEST_VAR: test
before:
  - echo "TEST"
      EOF

      file = write_config_to_file(config_content)
      cfg = Contur::Config.new(file.path)

      inspected_cfg = <<-EOF
Section 'version': 1.0
Section 'use': {"php"=>7.1, "mysql"=>"5.5.25"}
Section 'env': {"TEST_VAR"=>"test"}
Section 'before': [\"echo \\\"TEST\\\"\"]
      EOF
      inspected_cfg = inspected_cfg.chomp

      expect(cfg.errors).to be_empty
      expect(cfg.inspect).to eq inspected_cfg

      file.delete
    end
  end
end
