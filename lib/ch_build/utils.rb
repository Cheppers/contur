# frozen_string_literal: true
module CHBuild
  class Utils
    def self.generate_conatiner_name(prefix: nil, job_name: nil, build_id: nil)
      prefix ||= ENV['CONTAINER_PREFIX']
      job_name ||= ENV['JOB_NAME'] || self.random_string
      build_id ||= ENV['BUILD_ID'] || "r#{Random.rand(1000)}"

      unless prefix.nil? || prefix.empty?
        prefix = "#{prefix}-"
      end

      "#{prefix}#{job_name}-#{build_id}"
    end

    def self.random_string(length: 8)
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      (0...length).map { o[rand(o.length)] }.join
    end
  end
end
