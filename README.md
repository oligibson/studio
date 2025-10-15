# Studio

A simple way to interface with video generating AI models

## Installation
Install the dependencies:
```ruby
bundle install
```
Configure your API keys:
```ruby
Studio.configure do |config|
  config.openai_api_key = ENV['OPENAI_API_KEY']
end
```
## Working with Studio
```ruby
video = Studio.video
video.create 'A calico cat playing a piano on stage' 
```
```ruby
# Download a video
video.download('video_id')
```
```ruby
# Get details about the video
video.get('video_id')
```
```ruby
# Remix the video
video.remix('video_id', 'A cat playing piano in the street')
```
## Configuration
```ruby
# Change the default model used for a video and the download location
video = Studio.video('sora-2-pro', 'openai', 'tmp')
```
```ruby
# Change the model used for a specific video
video.with_model('sora-2-pro').create 'A calico cat playing a piano on stage'
```
