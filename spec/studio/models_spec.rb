# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Studio::Models do
  include_context 'with configured Studio'

  # Reset Models singleton after tests that modify it
  after do
    described_class.instance_variable_set(:@instance, nil)
  end

  describe 'filtering' do
    it 'filters models by provider' do
      openai_models = Studio.models.by_provider('openai')
      expect(openai_models.all).to all(have_attributes(provider: 'openai'))
    end

    it 'supports Enumerable methods' do
      # Count models by provider
      provider_counts = Studio.models.group_by(&:provider).transform_values(&:count)

      # There should be models from at least OpenAI and Anthropic
      expect(provider_counts.keys).to include('openai', 'gemini')
    end
  end

  describe 'finding models' do
    it 'finds models by ID' do
      # Find the default model
      model_id = Studio.config.default_model
      model = Studio.models.find(model_id)
      expect(model.id).to eq(model_id)

      # Find a model with chaining
      if Studio.models.by_provider('openai').any?
        openai_sora_id = Studio.models.by_provider('openai').first.id
        found = Studio.models.by_provider('openai').find(openai_sora_id)
        expect(found.id).to eq(openai_sora_id)
        expect(found.provider).to eq('openai')
      end
    end

    it 'raises ModelNotFoundError for unknown models' do
      expect do
        Studio.models.find('nonexistent-model-12345')
      end.to raise_error(Studio::Errors::ModelNotFoundError)
    end
  end

  describe '#find' do
    it 'search for model with and without provider' do
      video_model = Studio.video(model: 'veo-3.1-generate-preview')
      expect(video_model.model.id).to eq('veo-3.1-generate-preview')

      video_model = Studio.video(model: 'veo-3.1-generate-preview', provider: 'gemini')
      expect(video_model.model.id).to eq('veo-3.1-generate-preview')
    end
  end

  describe '#resolve' do
    it 'delegates to the class method when called on instance' do
      model_id = 'sora-2-pro'
      provider = 'openai'

      model_info, provider_instance = Studio.models.resolve(model_id, provider: provider)

      # expect(model_info).to be_a(Studio::Model::Info)
      expect(model_info.id).to eq(model_id)
      expect(model_info.provider).to eq(provider)
      expect(provider_instance).to be_a(Studio::Provider)
    end

    it 'resolves model without provider' do
      model_id = 'sora-2-pro'

      model_info, provider_instance = Studio.models.resolve(model_id)

      # expect(model_info).to be_a(Studio::Model::Info)
      expect(model_info.id).to eq(model_id)
      expect(provider_instance).to be_a(Studio::Provider)
    end
  end
end
