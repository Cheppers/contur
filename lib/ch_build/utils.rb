# frozen_string_literal: true
module CHBuild
  class Utils
    def self.generate_conatiner_name(prefix: nil, job_name: nil, build_id: nil)
      prefix ||= ENV['CONTAINER_PREFIX']
      unless prefix.nil? || prefix.empty?
        prefix = "#{prefix}-"
      end

      job_name ||= ENV['JOB_NAME'] || self.random_string
      build_id ||= ENV['BUILD_ID'] || "r#{Random.rand(1000)}"


      "#{prefix}#{job_name}-#{build_id}"
    end

    def self.virtual_hostanme(prefix: nil, job_name: nil, branch_name: nil)
      prefix ||= ENV['HOST_PREFIX']
      unless prefix.nil? || prefix.empty?
        prefix = "#{prefix}."
      end

      job_name ||= ENV['JOB_NAME'] || self.random_string.downcase
      branch_name ||= (ENV['BRANCH_NAME'] || "master").gsub(/.*\//, '')

      "#{prefix}#{branch_name}.#{job_name}"
    end

    def self.fqdn(prefix: nil, job_name: nil, branch_name: nil)
      vhost = self.virtual_hostanme(
        prefix: prefix,
        job_name: job_name,
        branch_name: branch_name
      )

      main_domain = ENV['DOMAIN'] || CHBuild::DEFAULT_DOMAIN

      "#{vhost}.#{main_domain}"
    end

    def self.random_string(length: 8)
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      (0...length).map { o[rand(o.length)] }.join
    end
  end
end
