# frozen_string_literal: true

module Studio
  # File Utilities shared across Studio components
  module Utils
    def self.generate_jwt(access_key:, secret_key:, expires_in: 1800, clock_skew: 5)
      raise ArgumentError, 'Access key missing' if access_key.to_s.empty?
      raise ArgumentError, 'Secret key missing' if secret_key.to_s.empty?

      current_time = Time.now.to_i
      payload = {
        iss: access_key,
        exp: current_time + expires_in,
        nbf: current_time - clock_skew
      }

      JWT.encode(payload, secret_key, 'HS256')
    end

    def prepare_output_path(output_dir, video_id)
      FileUtils.mkdir_p(output_dir)
      File.join(output_dir, "#{video_id}.mp4")
    end

    def write_stream(response, file_path)
      stream = response.respond_to?(:body) ? response.body : response

      dir = File.dirname(file_path)
      FileUtils.mkdir_p(dir) unless dir.nil? || dir == '.'

      File.open(file_path, 'wb') do |file|
        if stream.respond_to?(:each)
          stream.each { |chunk| file.write(chunk) }
        else
          file.write(stream.to_s)
        end
      end
    end
  end
end
