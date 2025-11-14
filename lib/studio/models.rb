# frozen_string_literal: true

module Studio
  # Registry of avaliable AI Video Generation Models
  class Models
    Info = Data.define(:id, :name, :provider, :family, :created_at, :modalities)

    class << self
      def instance
        @instance ||= new
      end

      def models_file
        File.expand_path('models.json', __dir__)
      end

      def resolve(model_id, provider: nil, config: nil)
        config ||= Studio.config

        model = find(model_id, provider)
        provider_class = Provider.providers[model.provider.to_sym] || raise(Error,
                                                                            "Unknown provider: #{model.provider}")
        provider_instance = provider_class.new(config)
        [model, provider_instance]
      end

      def find(model_id, provider = nil)
        if provider
          find_with_provider(model_id, provider)
        else
          find_without_provider(model_id)
        end
      end

      def initialize(models = nil)
        @models = models || load_models
      end

      def load_models
        @models = read_from_json
      end

      def read_from_json
        data = File.exist?(models_file) ? File.read(models_file) : '[]'
        JSON.parse(data, symbolize_names: true).map { |model| build_model_entry(model) }
      rescue JSON::ParserError
        []
      end

      def models
        @models ||= load_models
      end

      private

      def build_model_entry(attributes)
        normalized = default_model_attributes(attributes)
        Info.new(**normalized)
      end

      def default_model_attributes(attributes)
        {
          id: attributes[:id],
          name: attributes[:name],
          provider: attributes[:provider],
          family: attributes[:family],
          created_at: attributes[:created_at],
          modalities: attributes[:modalities] || {}
        }
      end

      def find_with_provider(model_id, provider)
        models.find { |m| m.id == model_id && m.provider == provider.to_s } ||
          raise(Studio::Errors::ModelNotFoundError, "Model '#{model_id}' not found with provider '#{provider}'")
      end

      def find_without_provider(model_id)
        models.find { |m| m.id == model_id } ||
          raise(Studio::Errors::ModelNotFoundError, "Model '#{model_id}' not found")
      end
    end
  end
end
