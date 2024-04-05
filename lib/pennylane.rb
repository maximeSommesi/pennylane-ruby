# frozen_string_literal: true

require_relative "pennylane/version"
require 'pennylane/configuration'
require 'httparty'
require 'ostruct'

Dir["./lib/pennylane/resources/*.rb"].each {|file| require file }


module Pennylane
  class Error < StandardError; end
  class AuthenticationError < Error; end
  class ConfigurationError < Error; end


  @config = Pennylane::Configuration.new
  # So we can have a module Pennylane that can be a class as well Pennylane.api_key = '1234'
  class << self
    extend Forwardable
    def_delegators :@config, :api_key, :api_key=
  end
end