module Pennylane
  class Configuration
    attr_accessor :api_key, :api_version
    
    class << self
      def current
        Thread.current[:pennylane_configuration] ||= new
      end

      def current=(configuration)
        raise ArgumentError, "Configuration invalide" unless configuration.is_a?(Configuration)
        Thread.current[:pennylane_configuration] = configuration
      end

      def reset!
        Thread.current[:pennylane_configuration] = new
      end
    end

    def initialize(api_key: nil, api_version: 'v1')
      @api_key = api_key
      @api_version = api_version || 'v1'
      validate!
    end

    def validate!
      raise ConfigurationError, "API key manquante" if api_key.nil?
      raise ConfigurationError, "Version d'API invalide" unless api_version.match?(/\Av\d+\z/)
      true
    end
  end
end