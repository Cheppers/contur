# frozen_string_literal: true
module Contur
  # Utils class
  class Utils
    def self.generate_conatiner_name(prefix: nil, job_name: nil, build_id: nil)
      prefix ||= ENV['CONTAINER_PREFIX']
      prefix = "#{prefix}-" unless prefix.nil? || prefix.empty?

      job_name ||= ENV['JOB_NAME'] || random_string
      build_id ||= ENV['BUILD_ID'] || "r#{Random.rand(1000)}"

      "#{prefix}#{job_name}-#{build_id}"
    end

    def self.virtual_hostname(prefix: nil, job_name: nil, branch_name: nil)
      prefix ||= ENV['HOST_PREFIX']
      prefix = "#{prefix}." unless prefix.nil? || prefix.empty?

      job_name ||= ENV['JOB_NAME'] || random_string.downcase
      branch_name ||= (ENV['BRANCH_NAME'] || 'master').gsub(%r{.*/}, '')

      "#{prefix}#{branch_name}.#{job_name}"
    end

    def self.fqdn(prefix: nil, job_name: nil, branch_name: nil)
      vhost = virtual_hostname(
        prefix: prefix,
        job_name: job_name,
        branch_name: branch_name
      )

      main_domain = ENV['DOMAIN'] || Contur::DEFAULT_DOMAIN

      "#{vhost}.#{main_domain}"
    end

    def self.random_string(length: 8)
      o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
      (0...length).map { o[rand(o.length)] }.join
    end
  end
end
