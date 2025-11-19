# Ruby Studio

Studio provides a unified Ruby interface for creating, monitoring, and downloading AI-generated videos. It currently supports OpenAI Sora, Google Gemini Veo and KlingAI Video Models. It draws inspiration from the RubyLLM project.

## Installation
Install the dependencies:
```ruby
bundle install
```
Configure your API keys:
```ruby
Studio.configure do |config|
  config.openai_api_key = ENV['OPENAI_API_KEY']
  config.gemini_api_key = ENV['GEMINI_API_KEY']
  config.kling_access_key = ENV['KLING_ACCESS_KEY']
  config.kling_secret_key = ENV['KLING_SECRET_KEY']
end
```
## Working with Studio
```ruby
video = Studio.video
video.create 'A calico cat playing a piano on stage'
```
```ruby
# Download a video
video.save('path/to/file')
```
```ruby
# Get details about the video
video.status
```
```ruby
# Change the default model used for a video, the download location, and the aspect ratio
video = Studio.video(model: 'sora-2-pro', provider: 'openai', output_dir:'tmp', aspect_ratio: "9:16")
```
```ruby
# Change the model used for a specific video
video.with_model('sora-2-pro').create 'A calico cat playing a piano on stage'
```
```ruby
# Change the aspect ratio for a specific video
video.with_ratio('16:9').create 'A calico cat playing a piano on stage'
```
```ruby
# Change the length of video generated
video.create('A calico cat playing a piano on stage', seconds: 8)
```
## Configure
The aim is to be able to configure once and use everywhere, but be able to override if needed.

```ruby
Studio.configure do |config|
  config.default_model = 'sora-2' # See models.json for avaliable id's
  config.default_aspect_ratio = '9:16' # or '16:9'
  config.output_directory = 'videos'
end
```
