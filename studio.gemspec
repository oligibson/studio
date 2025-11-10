# frozen_string_literal: true

require_relative 'lib/studio/version'

Gem::Specification.new do |spec|
  spec.name          = 'studio'
  spec.version       = Studio::VERSION
  spec.authors       = ['Oli Gibson']
  spec.email         = ['oli@calbrio.com']

  spec.summary       = 'Interface with AI video generation providers from Ruby.'
  spec.description   = <<~DESC
    Studio provides a unified Ruby interface for creating, monitoring, and downloading
    AI-generated videos. It currently supports OpenAI Sora and Google Gemini Veo and
    draws inspiration from the RubyLLM project.
  DESC

  spec.homepage = 'https://github.com/oligibson/studio'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.2.0')

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'bug_tracker_uri' => "#{spec.homepage}/issues",
    'documentation_uri' => spec.homepage,
    'changelog_uri' => "#{spec.homepage}/commits/main",
    'rubygems_mfa_required' => 'true'
  }

  spec.files         = Dir.glob('lib/**/*') + ['README.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 1.10.0'
  spec.add_dependency 'faraday-follow_redirects', '>= 0.4.0'
  spec.add_dependency 'zeitwerk', '>= 2.6'
end
