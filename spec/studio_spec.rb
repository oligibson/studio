# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Studio do
  describe '#providers' do
    it 'returns all registered providers' do
      expect(described_class.providers).to match_array(Studio::Provider.providers.values)
    end
  end
end
