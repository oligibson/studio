# frozen_string_literal: true

unless ENV['SKIP_COVERAGE']
  SimpleCov.start do
    track_files 'lib/**/*.rb'
    add_filter '/spec/'

    enable_coverage :branch

    formatter SimpleCov::Formatter::MultiFormatter.new(
      [
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::SimpleFormatter,
        (SimpleCov::Formatter::Codecov if ENV['CODECOV_TOKEN'])
      ].compact
    )
  end
end
