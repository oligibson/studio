# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Studio::Providers::Gemini::Capabilities do
  describe '#supported_durations' do
    it 'return the avaliable durations for Veo 2.0' do
      expect(described_class.supported_durations('veo-2.0-generate-001')).to match_array(%w[5 6 8])
    end

    it 'return the avaliable durations for other veo models' do
      expect(described_class.supported_durations('veo-3.0')).to match_array(%w[4 6 8])
    end
  end

  describe '#validate_parameters!' do
    let(:model_id) { 'veo-2.0-generate-001' }
    let(:valid_seconds) { 5 }
    let(:valid_aspect_ratio) { '16:9' }

    it 'accepts supported aspect ratios and durations' do
      expect do
        described_class.validate_parameters!(
          model_id: model_id,
          seconds: valid_seconds,
          aspect_ratio: valid_aspect_ratio
        )
      end.not_to raise_error
    end

    it 'rejects unsupported aspect ratios' do
      expect do
        described_class.validate_parameters!(
          model_id: model_id,
          seconds: valid_seconds,
          aspect_ratio: '4:3'
        )
      end.to raise_error(Studio::Errors::UnsupportedParameter, /aspect ratio/i)
    end

    it 'rejects unsupported durations' do
      expect do
        described_class.validate_parameters!(
          model_id: model_id,
          seconds: 10,
          aspect_ratio: valid_aspect_ratio
        )
      end.to raise_error(Studio::Errors::UnsupportedParameter, /duration/i)
    end
  end
end
