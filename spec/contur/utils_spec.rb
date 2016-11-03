# frozen_string_literal: true
require 'contur/utils'

describe Contur::Utils do
  it '#generate_container_name' do
    container_name = Contur::Utils.generate_conatiner_name(
      prefix: 'test',
      job_name: 'some_job',
      build_id: '3241'
    )
    expect(container_name).to eq 'test-some_job-3241'
  end

  it '#virtual_hostname' do
    container_name = Contur::Utils.virtual_hostname(
      prefix: 'test',
      job_name: 'some_job',
      branch_name: 'master'
    )
    expect(container_name).to eq 'test.master.some_job'
  end

  it '#fqdn' do
    container_name = Contur::Utils.fqdn(
      prefix: 'test',
      job_name: 'some_job',
      branch_name: 'master'
    )
    expect(container_name).to eq 'test.master.some_job.cheppers.com'
  end

  it '#random_string' do
    string = Contur::Utils.random_string(length: 8)

    expect(string.length).to be 8
    expect(string).to match(/[a-zA-Z]/)
  end
end
