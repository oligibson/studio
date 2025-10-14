# frozen_string_literal: true

# File Utilities shared across Studio components
module Studio
  module Utils
    def prepare_output_path(output_dir, video_id)
      FileUtils.mkdir_p(output_dir)
      File.join(output_dir, "#{video_id}.mp4")
    end

    def write_stream(response, file_path)
      stream = response.respond_to?(:body) ? response.body : response

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
