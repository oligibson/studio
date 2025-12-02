# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'

RSpec.describe Studio::Video do
  include_context 'with configured Studio'

  describe 'basic video generation functionality' do
    TEXT_TO_VIDEO_MODELS.each do |model_info|
      model = model_info[:model]
      provider = model_info[:provider]

      it "#{provider}/#{model} can create a video" do
        video = Studio.video(model: model, provider: provider)
        response = video.create('A calico cat playing a piano on stage', seconds: seconds_for(provider))

        expect(response.id).to be_present
        expect(response.model_id).to eq(model)
        expect(response.prompt).to include('cat')
      end

      it "#{provider}/#{model} can get the status of a video being generated" do
        video = Studio.video(model: model, provider: provider)
        response = video.create('A calico cat playing a piano on stage', seconds: seconds_for(provider))
        status = response.status

        # TODO: Status should return a concistent object
        case provider
        when :openai
          expect(status['id']).to be_present
        when :gemini
          expect(status['name']).to be_present
        when :kling
          expect(status['request_id']).to be_present
          expect(status['message']).to eq('SUCCEED')
        else
          skip 'Provider not supported'
        end
      end

      it "#{provider}/#{model} can download the generated video" do
        sleep_interval = VCR.current_cassette&.recording? ? 45 : 0

        video = Studio.video(model: model, provider: provider)
        response = video.create('A calico cat playing a piano on stage', seconds: seconds_for(provider))
        skip 'Video generation did not complete in time' unless wait_for_completion?(response, provider: provider,
                                                                                               interval: sleep_interval)

        Tempfile.create(['video', '.mp4']) do |tmp|
          saved = response.save(tmp.path)
          expect(saved).to eq(tmp.path)
          expect(File.exist?(saved)).to be(true)
          expect(File.size(saved)).to be > 1024
        end
      end
    end
  end
end

# TODO: Rewrite to handle complete status for Gemini and Kling
def status_completed?(status, provider = nil)
  return false unless status.is_a?(Hash)

  case provider
  when :gemini
    done_value = status.key?('done') ? status['done'] : status[:done]
    !!done_value
  when :kling
    data = status['data'] || status[:data] || {}
    task_status = data['task_status'] || data[:task_status]
    task_status.to_s == 'succeed'
  else
    state = status['status'] || status[:status]
    state == 'completed'
  end
end

def wait_for_completion?(film, provider:, max_attempts: 10, interval: 45)
  attempts = 0
  status = film.status
  until status_completed?(status, provider) || attempts >= max_attempts
    sleep(interval)
    status = film.status
    attempts += 1
  end
  status_completed?(status, provider)
end

def seconds_for(provider)
  provider == :kling ? 5 : 4
end
